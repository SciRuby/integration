require 'benchmark'
require 'integration'

METHODS = [:rectangle, :trapezoid, :simpson, :romberg, :adaptive_quadrature,
           :gauss, :gauss_kronrod, :simpson3by8, :boole, :open_trapezoid,
           :milne, :qng, :qag]
TOL = 1e-9
ITERATIONS = 100

# Function used in the benchmark.
f = -> x { x }

puts "Benchmarking with #{ITERATIONS} iterations"

Benchmark.bmbm(25) do |bm|
  METHODS.each do |method|
    params = { method: method, tolerance: TOL }
    bm.report(method.to_s) { ITERATIONS.times { Integration.integrate(0, 1, params, &f) } }
  end
end
