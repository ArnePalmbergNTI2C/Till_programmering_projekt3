require 'ruby2d'

set width: 1091
set height: 745

@speed_1 = 0.0
@speed_2 = 0.0

@maxspeed = 23

@bob2_1 = 1.0
@bob_1 = 1.0
@bob2_2 = 1.0
@bob_2 = 1.0

@text_cool = 0.0

SHOT = Sound.new('ljud/swing.mp3')
HOLE = Sound.new('ljud/hole.mp3')

@change_in_size_ball = 1
@ball_radius = 12.5 * @change_in_size_ball

@shot_1 = 0
@shot_2 = 0

class Player

    attr_reader :golfboll, :golfboll_skugga, :arrow

    #skapar massa grejer
    def initialize(x, color, change_in_size_ball, ball_radius)

        @golfboll = Sprite.new(
            'grejer/ball.png',
            x: x - ball_radius,
            y: Window.height - (Window.height / 5) - ball_radius,
            width: ball_radius * 2,
            height: ball_radius * 2,
            color: color,
            z: 11
        )
        @golfboll_skugga = Image.new(
            'grejer/ball_shadow.png',
            x: x - ball_radius,
            y: Window.height - (Window.height / 5) - ball_radius + 6,
            width: ball_radius * 2,
            height: ball_radius * 2,
            color: color,
            z: 10

        )

        @arrow = Image.new(
            'grejer/point1.png',
            width: 28 * change_in_size_ball,
            height: 150 * change_in_size_ball,
            z: 10
        )
        @arrow.remove
    end

end

class Game

    attr_reader :black_bar, :yellow_bar, :big_black_bar, :bar_height, :game_started, :hole, :block, :text_power, :text_shot_1, :text_shot_2

    #skapar massa grejer
    def initialize(change_in_size_ball, ball_radius)

        @bg = Image.new('grejer/bg.jpg')

        @hole_size = ball_radius * 2 * change_in_size_ball  * 1.75

        @hole = Image.new(
            'grejer/hole.png',
            x: (Window.width / 2) - (@hole_size / 2),
            y: (Window.height / 5) - (@hole_size / 2),
            width: @hole_size,
            height: @hole_size,
            z: 0

        )

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

        @text_shot_1 = Text.new(
            0,
            x: 100,
            y: 1,
            font: 'grejer/text.ttf',
            style: 'bold',
            size: text_power_size * 2,
            color: 'black',
            z: 0
        )

        @text_shot_2 = Text.new(
            0,
            x: 991,
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

game = Game.new(@change_in_size_ball, @ball_radius)
player1 = Player.new(100, "yellow", @change_in_size_ball, @ball_radius)
player2 = Player.new(991, "blue", @change_in_size_ball, @ball_radius)

#när man trycker på musen
on :mouse_down do |event|

    @mouse_down_on_ball_1 = false
    @mouse_down_on_ball_2 = false

    #ränkar ut position där man klicka
    @boll_position_x = event.x.to_f
    @boll_position_y = event.y.to_f

    #om man klickar på bollen
    if player1.golfboll.contains? @boll_position_x, @boll_position_y and @speed_1 == 0

        game.text_power.add

        #sätter positionen mitt i bollen
        @boll_position_x = player1.golfboll.x.to_f + @ball_radius
        @boll_position_y = player1.golfboll.y.to_f + @ball_radius

        #lägger till power grejen
        game.yellow_bar.add
        game.black_bar.add
        game.big_black_bar.add

        #ändrar position på pilen och lägger till den. VET INTE VARFÖR 63 MEN DET FUNGERADE
        player1.arrow.x = player1.golfboll.x - 2
        player1.arrow.y = (player1.golfboll.y - ( 63 * @change_in_size_ball))
        player1.arrow.add

        @mouse_down_on_ball_1 = true

    elsif player2.golfboll.contains? @boll_position_x, @boll_position_y and @speed_2 == 0

        game.text_power.add

        #sätter positionen mitt i bollen
        @boll_position_x = player2.golfboll.x.to_f + @ball_radius
        @boll_position_y = player2.golfboll.y.to_f + @ball_radius

        #lägger till power grejen
        game.yellow_bar.add
        game.black_bar.add
        game.big_black_bar.add

        #ändrar position på pilen och lägger till den. VET INTE VARFÖR 63 MEN DET FUNGERADE
        player2.arrow.x = player2.golfboll.x - 2
        player2.arrow.y = (player2.golfboll.y - ( 63 * @change_in_size_ball))
        player2.arrow.add

        @mouse_down_on_ball_2 = true

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
    if player1.golfboll.contains? @boll_position_x, @boll_position_y and @speed_1 == 0 and change_in_x.abs > 0.1 and change_in_y.abs > 0.1 and @mouse_down_on_ball_1 == true

        @mouse_down_on_ball_1 = false

        game.text_power.remove

        @shot_1 += 1
        game.text_shot_1.text = "#{@shot_1}"

        SHOT.play

        #tar bort pilen 
        player1.arrow.remove

        #tar bort power grejen
        game.yellow_bar.remove
        game.black_bar.remove
        game.big_black_bar.remove

        #sätter farten och max fart
        @speed_1 = (Math.sqrt(change_in_x **2 + change_in_y ** 2)) / 8
        if @speed_1 > @maxspeed
            @speed_1 = @maxspeed
        end
        if @speed_y_1 > @maxspeed
            @speed_y_1 = @maxspeed
        end
        @speed_x_1 = @speed_1
        @speed_y_1 = @speed_1

        #sätter riktningen på bollen
        if change_in_x < 0 
            @speed_x_1 = -@speed_x_1
        end
        if change_in_y < 0 
            @speed_y_1 = -@speed_y_1
        end

        #skillnaden i sidled
        if (change_in_x).abs > (change_in_y).abs
            @bob_1 = (change_in_x / change_in_y).abs
            @bob2_1 = 1
        else
            @bob2_1 = (change_in_y / change_in_x).abs
            @bob_1 = 1
        end  
    elsif player2.golfboll.contains? @boll_position_x, @boll_position_y and @speed_2 == 0 and change_in_x.abs > 0.1 and change_in_y.abs > 0.1 and @mouse_down_on_ball_2 == true

        @mouse_down_on_ball_2 = false

        game.text_power.remove

        @shot_2 += 1
        game.text_shot_2.text = "#{@shot_2}"

        SHOT.play

        #tar bort pilen 
        player2.arrow.remove

        #tar bort power grejen
        game.yellow_bar.remove
        game.black_bar.remove
        game.big_black_bar.remove

        #sätter farten och max fart
        @speed_2 = (Math.sqrt(change_in_x **2 + change_in_y ** 2)) / 8
        if @speed_2 > @maxspeed
            @speed_2 = @maxspeed
        end
        if @speed_y_2 > @maxspeed
            @speed_y_2 = @maxspeed
        end
        @speed_x_2 = @speed_2
        @speed_y_2 = @speed_2

        #sätter riktningen på bollen
        if change_in_x < 0 
            @speed_x_2 = -@speed_x_2
        end
        if change_in_y < 0 
            @speed_y_2 = -@speed_y_2
        end

        #skillnaden i sidled
        if (change_in_x).abs > (change_in_y).abs
            @bob_2 = (change_in_x / change_in_y).abs
            @bob2_2 = 1
        else
            @bob2_2 = (change_in_y / change_in_x).abs
            @bob_2 = 1
        end  

    end

end

update do

    #om spelet är startat
    if game.game_started == true 
        
        #hur mycket power man har och vad som visas då
        if @mouse_down_on_ball_1 == true
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

            #var pilen är och pekar för boll 1
            old_angle = 180
            if @speed_1 == 0
                current_x = Window.mouse_x.to_f
                current_y = Window.mouse_y.to_f
                
                change_in_x = @boll_position_x - current_x
                change_in_y = @boll_position_y - current_y 

                arc_tangent = Math.atan2(change_in_x, change_in_y)
                arc_tangent_degrees = arc_tangent * (180 / Math::PI)
                arc_tangent_degrees = -arc_tangent_degrees

                player1.arrow.rotate = old_angle + arc_tangent_degrees
                old_angle = player1.arrow.rotate
            end

        elsif @mouse_down_on_ball_2 == true

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

            #var pilen är och pekar för boll 2
            old_angle = 180
            if @speed_2 == 0
                current_x = Window.mouse_x.to_f
                current_y = Window.mouse_y.to_f
                
                change_in_x = @boll_position_x - current_x
                change_in_y = @boll_position_y - current_y 

                arc_tangent = Math.atan2(change_in_x, change_in_y)
                arc_tangent_degrees = arc_tangent * (180 / Math::PI)
                arc_tangent_degrees = -arc_tangent_degrees

                player2.arrow.rotate = old_angle + arc_tangent_degrees
                old_angle = player2.arrow.rotate
            end

        end

        #om man träffar hålet
        if game.hole.contains? player1.golfboll.x + @ball_radius, player1.golfboll.y + @ball_radius
            @speed_1 = 0

            HOLE.play

            @shot_1 = 0

            game.text_shot_1.text = "#{@shot_1}"

            player1.golfboll.x = 100
            player1.golfboll.y = Window.height - (Window.height / 5) - @ball_radius + (@change_in_size_ball)
            player1.golfboll_skugga.x = 100
            player1.golfboll_skugga.y = Window.height - (Window.height / 5) - @ball_radius + 6

        elsif game.hole.contains? player2.golfboll.x + @ball_radius, player2.golfboll.y + @ball_radius

            @speed_2 = 0

            HOLE.play

            @shot_2 = 0

            game.text_shot_2.text = "#{@shot_2}"

            player2.golfboll.x = 991
            player2.golfboll.y = Window.height - (Window.height / 5) - @ball_radius + (@change_in_size_ball)
            player2.golfboll_skugga.x = 991
            player2.golfboll_skugga.y = Window.height - (Window.height / 5) - @ball_radius + 6
        end

        #nuddar väggen ska bollen byta rikting
        if player1.golfboll.x < 0 or player1.golfboll.x > (Window.width - player1.golfboll.width) 
            @speed_x_1 = -@speed_x_1
        end
        if player1.golfboll.y < 0 or player1.golfboll.y > (Window.height - player1.golfboll.width)
            @speed_y_1 = -@speed_y_1
        end
        if player2.golfboll.x < 0 or player2.golfboll.x > (Window.width - player1.golfboll.width) 
            @speed_x_2 = -@speed_x_2
        end
        if player2.golfboll.y < 0 or player2.golfboll.y > (Window.height - player1.golfboll.width)
            @speed_y_2 = -@speed_y_2
        end

        #nuddar blocket ska bollen byta rikting
        if game.block.contains? player1.golfboll.x + @ball_radius, player1.golfboll.y or game.block.contains? player1.golfboll.x + @ball_radius, player1.golfboll.y + (@ball_radius * 2)
            @speed_y_1 = -@speed_y_1
        elsif game.block.contains? player1.golfboll.x, player1.golfboll.y + @ball_radius or game.block.contains? player1.golfboll.x + (@ball_radius * 2), player1.golfboll.y + @ball_radius 
            @speed_x_1 = -@speed_x_1
        elsif game.block.contains? player2.golfboll.x + @ball_radius, player2.golfboll.y or game.block.contains? player2.golfboll.x + @ball_radius, player2.golfboll.y + (@ball_radius * 2)
            @speed_y_2 = -@speed_y_2
        elsif game.block.contains? player2.golfboll.x, player2.golfboll.y + @ball_radius or game.block.contains? player2.golfboll.x + (@ball_radius * 2), player2.golfboll.y + @ball_radius 
            @speed_x_2 = -@speed_x_2
        end

        #friktion i boll1
        if @speed_1.abs > 0.5
            @speed_1 = @speed_1 * 0.985
            @speed_x_1 = @speed_x_1 * 0.985
            @speed_y_1 = @speed_y_1 * 0.985
        elsif @speed_1.abs <= 0.5 && @speed_1.abs > 0.05
            @speed_1 = @speed_1 * 0.90
            @speed_x_1 = @speed_x_1 * 0.90
            @speed_y_1 = @speed_y_1 * 0.90
        elsif @speed_1.abs <= 0.05
            @speed_1 = 0
            @speed_x_1 = 0
            @speed_y_1 = 0
        end

        #friktion i boll2
        if @speed_2.abs > 0.5
            @speed_2 = @speed_2 * 0.985
            @speed_x_2 = @speed_x_2 * 0.985
            @speed_y_2 = @speed_y_2 * 0.985
        elsif @speed_2.abs <= 0.5 && @speed_2.abs > 0.05
            @speed_2 = @speed_2 * 0.90
            @speed_x_2 = @speed_x_2 * 0.90
            @speed_y_2 = @speed_y_2 * 0.90
        elsif @speed_2.abs <= 0.05
            @speed_2 = 0
            @speed_x_2 = 0
            @speed_y_2 = 0
        end

        #uppdatera farten
        player1.golfboll.x += @speed_x_1 / @bob2_1
        player1.golfboll.y += @speed_y_1 / @bob_1
        player1.golfboll_skugga.x += @speed_x_1 / @bob2_1
        player1.golfboll_skugga.y += @speed_y_1 / @bob_1
        player2.golfboll.x += @speed_x_2 / @bob2_2
        player2.golfboll.y += @speed_y_2 / @bob_2
        player2.golfboll_skugga.x += @speed_x_2 / @bob2_2
        player2.golfboll_skugga.y += @speed_y_2 / @bob_2
    end
end
 
show