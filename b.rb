def vokal(sti)

    konsonant = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w' 'x', 'z']

    i = 0
    
    while i < konsonant.length

        if bokstav == konsonant[i]


        end

        i += 1
    end


end

def rovarsprok(string)

    new_array = ""

    konsonant = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w' 'x', 'z']

    i = 0
    
    while i < string.length
        j = 0
        nanting = false
        while j < konsonant.length
            if string[i] == konsonant[j]
                nanting = true
                new_array << konsonant[j] + "o" + konsonant[j]
            end
            j +=1
        end

        if nanting == false
            new_array << string[i]
        end


        i += 1
    end

    return new_array

end


hej = File.readlines("random.txt")
p hej[0]


p rovarsprok(hej[0])

variabel = File.open("rovarspak.txt", "w")
variabel.puts(rovarsprok(hej[0]))
variabel.close

