require 'ruby2d'

set width: 1091
set height: 745

@text_cool = 0
@text_power = Text.new(
    @text_cool,
    x: 0, y: 300,
    font: 'grejer/text.ttf',
    style: 'bold',
    size: 20,
    color: 'blue',
    z: 0
)

@bar_height = 150.0
@cool = 100.0

update do

    @bar_height = rand(1..10000)
    p @cool
    @text_cool = @bar_height
    p @text_cool
    @text_power.text = @text_cool

    sleep (1)

    p @text_power

end

show