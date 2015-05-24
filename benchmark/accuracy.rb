require 'integration'
require 'text-table'

METHODS = [:rectangle, :trapezoid, :simpson, :romberg, :adaptive_quadrature,
           :gauss, :gauss_kronrod, :simpson3by8, :boole, :open_trapezoid,
           :milne, :qng, :qag]
TOL = 1e-9

# Function used in the benchmark.
f = -> x { x }

# Correct result of the integral of `f` in [0, 1].
actual_result = 5 / 2.0 + 2 * Math.sin(1)

table = Text::Table.new
table.head = ['Method', 'Error', 'Accuracy']

METHODS.each do |method|
  result = Integration.integrate(0, 1, { method: method }, &f)

  if result.nil?
    puts method
  else
    error = (actual_result - result).abs
    table.rows << [method, error, 100 * (1 - error / actual_result.to_f)]
  end
end

puts table.to_s
