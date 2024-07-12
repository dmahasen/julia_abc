module Julia_ABC
export greetings
export sir 

greet() = print("Hello World!")

include("greetings.jl")
include("sir.jl")

end # module Julia_ABC
