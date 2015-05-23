# Copyright (c) 2005  Beng (original code)
#               2011  Claudio Bustos
#               XXXX -> Add new developers
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE X CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
# OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Except as contained in this notice, the name of the Beng shall not
# be used in advertising or otherwise to promote the sale, use or other dealings
# in this Software without prior written authorization from Beng.

require 'integration/methods'

# Diverse integration methods
# Use Integration.integrate as wrapper to direct access to methods
#
class Integration

  # Minus Infinity
  MInfinity = :minfinity

  # Infinity
  Infinity = :infinity

  # Pure Ruby methods available.
  RUBY_METHODS = [:rectangle, :trapezoid, :simpson, :adaptive_quadrature,
                 :gauss, :romberg, :monte_carlo, :gauss_kronrod,
                 :simpson3by8, :boole, :open_trapezoid, :milne]

  # Methods available when using the `rb-gsl` gem.
  GSL_METHODS = [:qng, :qag]

  class << self

    # Check if `value` is plus or minus infinity.
    #
    # @param value Value to be tested.
    def infinite?(value)
      value == Integration::Infinity || value == Integration::MInfinity
    end

    # Get the integral for a function +f+, with bounds +t1+ and +t2+ given a
    # hash of +options+. If Ruby/GSL is available, you can use
    # +Integration::Minfinity+ and +Integration::Infinity+ as bounds. Method
    #
    # Options are:
    # [:tolerance]    Maximum difference between real and calculated integral.
    #                 Default: 1e-10.
    # [:initial_step] Initial number of subdivisions.
    # [:step]         Subdivition increment on each iteration.
    # [:method]       Integration method.
    #
    # Available methods are:
    #
    # [:rectangle] for [:initial_step+:step*iteration] quadrilateral subdivisions.
    # [:trapezoid] for [:initial_step+:step*iteration] trapezoid-al subdivisions.
    # [:simpson]   for [:initial_step+:step*iteration] parabolic subdivisions.
    # [:adaptive_quadrature] for recursive appoximations until error [tolerance].
    # [:gauss] [:initial_step+:step*iteration] weighted subdivisons using
    # translated -1 -> +1 endpoints.
    # [:romberg] extrapolation of recursion approximation until error < [tolerance].
    # [:monte_carlo] make [:initial_step+:step*iteration] random samples, and
    # check for above/below curve.
    # [:qng] GSL QNG non-adaptive Gauss-Kronrod integration.
    # [:qag] GSL QAG adaptive integration, with support for infinite bounds.
    def integrate(t1, t2, options = {}, &f)
      inf_bounds = (infinite?(t1) || infinite?(t2))

      fail 'No function passed' unless block_given?
      fail 'Non-numeric bounds' unless ((t1.is_a? Numeric) && (t2.is_a? Numeric)) || inf_bounds

      if inf_bounds
        lower_bound = t1
        upper_bound = t2
        options[:method] = :qag if options[:method].nil?
      else
        lower_bound = [t1, t2].min
        upper_bound = [t1, t2].max
      end

      def_method = (has_gsl?) ? :qag : :simpson
      default_opts = { tolerance: 1e-10, initial_step: 16, step: 16, method: def_method }
      options = default_opts.merge(options)

      if RUBY_METHODS.include? options[:method]
        fail "Ruby methods doesn't support infinity bounds" if inf_bounds
        integrate_ruby(lower_bound, upper_bound, options, &f)
      elsif GSL_METHODS.include? options[:method]
        integrate_gsl(lower_bound, upper_bound, options, &f)
      else
        fail "Unknown integration method \"#{options[:method]}\""
      end
    end

    # Integrate using the GSL bindings.
    def integrate_gsl(lower_bound, upper_bound, options, &f)
      f = GSL::Function.alloc(&f)
      method = options[:method]
      tolerance = options[:tolerance]

      if (method == :qag)
        w = GSL::Integration::Workspace.alloc

        val = if infinite?(lower_bound) && infinite?(upper_bound)
          f.qagi([tolerance, 0.0], 1000, w)
        elsif infinite?(lower_bound)
          f.qagil(upper_bound, [tolerance, 0], w)
        elsif infinite?(upper_bound)
          f.qagiu(lower_bound, [tolerance, 0], w)
        else
          f.qag([lower_bound, upper_bound], [tolerance, 0.0], GSL::Integration::GAUSS61, w)
        end

      elsif (method == :qng)
        val = f.qng([lower_bound, upper_bound], [tolerance, 0.0])

      else
        fail "Unknown integration method \"#{method}\""
      end

      val[0]
    end

    def integrate_ruby(lower_bound, upper_bound, options, &f)
      method = options[:method]
      tolerance = options[:tolerance]
      initial_step = options[:initial_step]
      step = options[:step]
      points = options[:points]

      begin
        method_obj = Integration.method(method.to_s.downcase)
      rescue
        raise "Unknown integration method \"#{method}\""
      end

      current_step = initial_step

      if [:adaptive_quadrature, :romberg, :gauss, :gauss_kronrod].include? method
        if (method == :gauss)
          initial_step = 10 if initial_step > 10
          tolerance = initial_step
          method_obj.call(lower_bound, upper_bound, tolerance, &f)
        elsif (method == :gauss_kronrod)
          initial_step = 10 if initial_step > 10
          tolerance = initial_step
          points = points unless points.nil?
          method_obj.call(lower_bound, upper_bound, tolerance, points, &f)
        else
          method_obj.call(lower_bound, upper_bound, tolerance, &f)
        end
      else
        value = method_obj.call(lower_bound, upper_bound, current_step, &f)
        previous = value + (tolerance * 2)
        diffs = []

        while (previous - value).abs > tolerance
          diffs.push((previous - value).abs)
          current_step += step
          previous = value
          value = method_obj.call(lower_bound, upper_bound, current_step, &f)
        end

        value
      end
    end

    def create_has_library(library) #:nodoc:
      define_singleton_method("has_#{library}?") do
        cv = "@@#{library}"
        unless class_variable_defined? cv
          begin
            require library.to_s
            class_variable_set(cv, true)
          rescue LoadError
            class_variable_set(cv, false)
          end
        end
        class_variable_get(cv)
      end
    end
  end

  create_has_library :gsl
end
