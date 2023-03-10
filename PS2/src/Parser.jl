"""
    _recursive_compound_parser()

TODO: Describe what this function does, the args and what we expect it to return
"""
function _recursive_compound_parser(q::Queue{Char}, elements::Array{Char, 1}, amount::Array{Int64,1})
# base case: we have no more characters in the character_arr - we are done
    if (isempty(q) == true)
        return nothing
#if not take the next charcter, see if its a number of a character in the queue and take it out to combine with list
    else
        next_char = dequeue!(q)
        if (isnumeric(next_char) == false)
            push!(elements, next_char)

        else
            if (isempty(q) == true)
                push!(amount, parse(Int, next_char))#combine with list
            else
                number = dequeue!(q)

                if (isnumeric(number) == true)
                    n = string(next_char, number)
                    N = parse(Int, n)
                    push!(amount, N)
                else
                    push!(amount, parse(Int, next_char))
                    push!(elements, number)
                end
            end
        end
    end
    _recursive_compound_parser(q, elements, amount)#take the next character and process it
end

"""
    recursive_compound_parser(compounds::Dict{String, MyChemicalCompoundModel}) -> Dict{String, MyChemicalCompoundModel}

TODO: Describe what this function does, the args and what we expect it to return 
"""
function recursive_compound_parser(compounds::Dict{String, MyChemicalCompoundModel})::Dict{String, MyChemicalCompoundModel}
    # initialize -
    for(name, model) in compounds
        d = Dict{Char, Int}()
        q = Queue{Char}()
        elements = Array{Char,1}()
        amount = Array{Int64, 1}()
    
        # build the Queue q that we are going to parse -
        character_arr = collect(model.molecule)
        for c ∈ character_arr
            enqueue!(q, c);
        end
        counter = 1
    
        # recursive descent -
        _recursive_compound_parser(q, elements, amount);
    
        # convert to dictionary for the output
        for item ∈ elements
            d[item] = amount[counter];
            counter += 1
        end
        model.d=d
    end

    # return the updated dictionary
    return compounds;
end