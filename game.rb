#koppsnurr

require 'ruby2d'

set width: 1091
set height: 745

@game_started = false

@speed = 0.0
@speed = 0.0
@speed = 0.0

@maxspeed = 23

@bob2 = 1.0
@bob = 1.0

@text_cool = 0.0

SHOT = Sound.new('ljud/swing.mp3')
HOLE = Sound.new('ljud/hole.mp3')

@shot = 0

class Game

    attr_reader :golfboll, :ball_radius, :arrow, :black_bar, :yellow_bar, :big_black_bar, :bar_height, :golfboll_skugga, :change_in_size_ball, :game_started, :hole, :block, :text_power, :text_shot

    #skapar massa grejer
    def initialize

        @shot = 0

        @bg = Image.new('grejer/bg.jpg')

        @change_in_size_ball = 1
        @ball_radius = 12.5 * @change_in_size_ball

        @golfboll = Sprite.new(
            'grejer/ball.png',
            x: (Window.width / 2) - @ball_radius,
            y: Window.height - (Window.height / 5) - @ball_radius,
            width: @ball_radius * 2,
            height: @ball_radius * 2,
            z: 11
        )
        @golfboll_skugga = Image.new(
            'grejer/ball_shadow.png',
            x: (Window.width / 2) - @ball_radius,
            y: Window.height - (Window.height / 5) - @ball_radius + 6,
            width: @ball_radius * 2,
            height: @ball_radius * 2,
            z: 10

        )

        @hole_size = @ball_radius * 2 * @change_in_size_ball  * 1.75

        @hole = Image.new(
            'grejer/hole.png',
            x: (Window.width / 2) - (@hole_size / 2),
            y: (Window.height / 5) - (@hole_size / 2),
            width: @hole_size,
            height: @hole_size,
            z: 0

        )

        @arrow = Image.new(
            'grejer/point1.png',
            width: 28 * @change_in_size_ball,
            height: 150 * @change_in_size_ball,
            z: 10
        )
        @arrow.remove

        @bar_height = 150
        @black_bar = Image.new(
            'grejer/powermeter_overlay.png',
            x: 10,
            y: (Window.height / 2) - (@bar_height / 2),
            z: 3,
            height: @bar_height,
            width: @bar_height / 6.25
        )
        @black_bar.remove

        @yellow_bar = Image.new(
            'grejer/powermeter_fg.png',
            x: 14,
            y: (Window.height / 2) - (@bar_height / 2),
            height: @bar_height,
            z: 2,
            width: (@bar_height / 6.25) - 8
        )
        @yellow_bar.remove

        @big_black_bar = Image.new(
            'grejer/powermeter_bg.png',
            x: 10,
            y: (Window.height / 2) - (@bar_height / 2),
            z: 1,
            height: @bar_height,
            width: @bar_height / 6.25
        )
        @big_black_bar.remove

        size = 150

        @block = Image.new(
            'grejer/block.png',
            x: (Window.width / 2) - (size / 2),
            y: (Window.height / 2) - (size / 2),
            z: 1,
            height: size,
            width: size
        )
        @block_bg = Image.new(
            'grejer/block_bg.png',
            x: (Window.width / 2) - (size / 2),
            y: (Window.height / 2) - (size / 2),
            z: 0,
            height: size * 1.046875,
            width: size
        )

        text_power_size = 20

        @text_power = Text.new(
            @text_cool,
            x: 5, y: (Window.height / 2) - (@bar_height / 2) - (text_power_size),
            font: 'grejer/text.ttf',
            style: 'bold',
            size: text_power_size,
            color: 'black',
            z: 0
        )

        @text_power.remove

        @text_shot = Text.new(
            @shot,
            x: (Window.width / 2) - (text_power_size / 2),
            y: 1,
            font: 'grejer/text.ttf',
            style: 'bold',
            size: text_power_size * 2,
            color: 'black',
            z: 0
        )

        @game_started = true

    end

end

game = Game.new

#när man trycker på musen
on :mouse_down do |event|

    @mouse_down_on_ball = false

    #ränkar ut position där man klicka
    @boll_position_x = event.x.to_f
    @boll_position_y = event.y.to_f

    #om man klickar på bollen
    if game.golfboll.contains? @boll_position_x, @boll_position_y and @speed == 0

        game.text_power.add

        #sätter positionen mitt i bollen
        @boll_position_x = game.golfboll.x.to_f + game.ball_radius
        @boll_position_y = game.golfboll.y.to_f + game.ball_radius

        #lägger till power grejen
        game.yellow_bar.add
        game.black_bar.add
        game.big_black_bar.add

        #ändrar position på pilen och lägger till den. VET INTE VARFÖR 63 MEN DET FUNGERADE
        game.arrow.x = game.golfboll.x - 2
        game.arrow.y = (game.golfboll.y - ( 63 * game.change_in_size_ball))
        game.arrow.add

        @mouse_down_on_ball = true

    end
end

#när man lyfter musen
on :mouse_up do |event|

    #sätter värdet där man släppte musen
    current_x = event.x.to_f
    current_y = event.y.to_f

    #räknar ut skillnaden i x och y led på när man tryckte och släppte musen
    change_in_x = @boll_position_x - current_x
    change_in_y = @boll_position_y - current_y   

    #när man klickat på bollen och släpper musen
    if game.golfboll.contains? @boll_position_x, @boll_position_y and @speed == 0 and change_in_x.abs > 0.1 and change_in_y.abs > 0.1 and @mouse_down_on_ball == true

        @mouse_down_on_ball = false

        game.text_power.remove

        @shot += 1
        game.text_shot.text = "#{@shot}"

        SHOT.play

        #tar bort pilen 
        game.arrow.remove

        #tar bort power grejen
        game.yellow_bar.remove
        game.black_bar.remove
        game.big_black_bar.remove

        #sätter farten och max fart
        @speed = (Math.sqrt(change_in_x **2 + change_in_y ** 2)) / 8
        if @speed > @maxspeed
            @speed = @maxspeed
        end
        if @speed_y > @maxspeed
            @speed_y = @maxspeed
        end
        @speed_x = @speed
        @speed_y = @speed

        #sätter riktningen på bollen
        if change_in_x < 0 
            @speed_x = -@speed_x
        end
        if change_in_y < 0 
            @speed_y = -@speed_y
        end

        #skillnaden i sidled
        if (change_in_x).abs > (change_in_y).abs
            @bob = (change_in_x / change_in_y).abs
            @bob2 = 1
        else
            @bob2 = (change_in_y / change_in_x).abs
            @bob = 1
        end  
    end

end

update do

    if game.game_started == true 
        
        #hur mycket power man har och vad som visas
        if @mouse_down_on_ball == true
            @cool = (Math.sqrt((@boll_position_x - Window.mouse_x.to_f) **2 + (@boll_position_y - Window.mouse_y.to_f) ** 2)) / (8.0 / (game.bar_height / @maxspeed))
            
            if @cool + 10 < game.bar_height
                game.yellow_bar.y = ((Window.height / 2) + ((game.bar_height - 10) / 2)) - @cool
                game.yellow_bar.height = @cool
                @text_cool = ((@cool + 10) / game.bar_height).round(2)
                game.text_power.text = "#{@text_cool}%"
            else 
                game.yellow_bar.y = game.yellow_bar.y = ((Window.height / 2) + ((game.bar_height - 10) / 2)) - (game.bar_height - 10)
                game.yellow_bar.height = game.bar_height - 10
                game.text_power.text ="1.00%"

            end

            #var pilen är och pekar
            old_angle = 180
            if @speed == 0
                current_x = Window.mouse_x.to_f
                current_y = Window.mouse_y.to_f
                
                change_in_x = @boll_position_x - current_x
                change_in_y = @boll_position_y - current_y 

                arc_tangent = Math.atan2(change_in_x, change_in_y)
                arc_tangent_degrees = arc_tangent * (180 / Math::PI)
                arc_tangent_degrees = -arc_tangent_degrees

                game.arrow.rotate = old_angle + arc_tangent_degrees
                old_angle = game.arrow.rotate
            end
        end

        #om man träffar hålet
        if game.hole.contains? game.golfboll.x + game.ball_radius, game.golfboll.y + game.ball_radius
            @speed = 0

            HOLE.play

            @shot = 0

            game.text_shot.text = "#{@shot}"

            game.golfboll.x = (Window.width / 2) - game.ball_radius
            game.golfboll.y = Window.height - (Window.height / 5) - game.ball_radius + (game.change_in_size_ball)
            game.golfboll_skugga.x = (Window.width / 2) - game.ball_radius
            game.golfboll_skugga.y = Window.height - (Window.height / 5) - game.ball_radius + 6
        end

        #utanför skärmen ska den byta håll
        if game.golfboll.x < 0 or game.golfboll.x > (Window.width - game.golfboll.width) 
            @speed_x = -@speed_x
        elsif game.golfboll.y < 0 or game.golfboll.y > (Window.height - game.golfboll.width)
            @speed_y = -@speed_y
        end

        #nuddar blocket
        if game.block.contains? game.golfboll.x + game.ball_radius, game.golfboll.y or game.block.contains? game.golfboll.x + game.ball_radius, game.golfboll.y + (game.ball_radius * 2)
            @speed_y = -@speed_y
        end
        if game.block.contains? game.golfboll.x, game.golfboll.y + game.ball_radius or game.block.contains? game.golfboll.x + (game.ball_radius * 2), game.golfboll.y + game.ball_radius 
            @speed_x = -@speed_x
        end

        #friktion i bollen
        if @speed.abs > 0.5
            @speed = @speed * 0.985
            @speed_x = @speed_x * 0.985
            @speed_y = @speed_y * 0.985
        elsif @speed.abs <= 0.5 && @speed.abs > 0.05
            @speed = @speed * 0.90
            @speed_x = @speed_x * 0.90
            @speed_y = @speed_y * 0.90
        elsif @speed.abs <= 0.05
            @speed = 0
            @speed_x = 0
            @speed_y = 0
        end

        #uppdatera farten
        game.golfboll.x += @speed_x / @bob2
        game.golfboll.y += @speed_y / @bob
        game.golfboll_skugga.x += @speed_x / @bob2
        game.golfboll_skugga.y += @speed_y / @bob
    end
end
 
show