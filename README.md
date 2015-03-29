# Integration

[![Build Status](https://travis-ci.org/SciRuby/integration.svg?branch=master)](https://travis-ci.org/SciRuby/integration)
[![Code Climate](https://codeclimate.com/github/SciRuby/integration/badges/gpa.svg)](https://codeclimate.com/github/SciRuby/integration)

Numerical integration for Ruby, with a simple interface. Several different integration methods are implemented.

## Installation

```bash
$ gem install integration
```

You can install GSL (please use your package manager) for better performance and support for infinite bounds. After successfully installing the library:

```bash
$ gem install rb-gsl
```

## Documentation

You can see the latest documentation for Integration at Rubydoc: [rubydoc.info/github/sciruby/integration](http://www.rubydoc.info/github/sciruby/integration).

## Features

* Use only one method: Integration.integrate
* Rectangular, Trapezoidal, Simpson, Adaptive quadrature, Monte Carlo and Romberg integration methods available on pure Ruby.
* If available, uses Ruby/GSL QNG non-adaptive Gauss-Kronrod integration and QAG adaptive integration, with support for Infinity+ and Infinity-

## Examples

```ruby
# Integrate x^2 in [1, 2] using Simpson's rule.
Integration.integrate(1, 2, tolerance: 1e-10, method: :simpson) do |x|
  x**2
end
# => 2.333333

# Support for infinity bounds with GSL QAG adaptative integration.

normal_pdf = lambda do |x|
  (1 / Math.sqrt(2 * Math::PI)) * Math.exp(-0.5 * (x**2))
end

Integration.integrate(Integration::MInfinity, 0, tolerance: 1e-10, &normal_pdf) # => 0.5
Integration.integrate(0, Integration::Infinity , tolerance: 1e-10, &normal_pdf) # => 0.5
```

## License

Copyright (c) 2005  Beng
              2011-2015  clbustos

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
THE DEVELOPERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Except as contained in this notice, the name of the Beng shall not
be used in advertising or otherwise to promote the sale, use or other dealings
in this Software without prior written authorization from Beng.
