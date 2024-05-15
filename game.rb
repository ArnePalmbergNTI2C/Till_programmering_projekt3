#filma
#skriva reflektion

require 'ruby2d'

set width: 1091
set height: 745

@speed_1 = 0.0
@speed_2 = 0.0

@maxspeed = 23.0

@bob2_1 = 1.0
@bob_1 = 1.0
@bob2_2 = 1.0
@bob_2 = 1.0

@text_cool = 0.0

SHOT = Sound.new('ljud/swing.mp3')
HOLE = Sound.new('ljud/hole.mp3')

@change_in_size_ball = 1.0
@ball_radius = 12.5 * @change_in_size_ball

@shot_1 = 0
@shot_2 = 0

@level = 1
@level_counter = 0

@end_game = false
@start_bol = true


#klassen för olika spelare
class Player

    attr_reader :golfboll, :golfboll_skugga, :arrow

    #skapar massa grejer
    def initialize(x, color, change_in_size_ball, ball_radius)

        @golfboll = Sprite.new(
            'grejer/ball.png',
            x: x - ball_radius,
            y: Window.height - (Window.height / 5.0) - ball_radius,
            width: ball_radius * 2.0,
            height: ball_radius * 2.0,
            color: color,
            z: 11
        )
        @golfboll_skugga = Image.new(
            'grejer/ball_shadow.png',
            x: x - ball_radius,
            y: Window.height - (Window.height / 5.0) - ball_radius + 6,
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

#klassen för spelet
class Game

    attr_reader :black_bar, :yellow_bar, :big_black_bar, :bar_height, :hole, :text_power, :text_shot_1, :text_shot_2, :hole_size, :start_screen

    #skapar massa grejer
    def initialize(change_in_size_ball, ball_radius)

        @bg = Image.new('grejer/bg.jpg')

        @hole_size = (Window.width / 22.0) * change_in_size_ball

        @hole = Image.new(
            'grejer/hole.png',
            x: (Window.width / 2.0) - (@hole_size / 2.0),
            y: (Window.height / 5.0) - (@hole_size / 2.0),
            width: @hole_size,
            height: @hole_size,
            z: 0

        )

        @bar_height = 150
        @black_bar = Image.new(
            'grejer/powermeter_overlay.png',
            x: 10,
            y: (Window.height / 2.0) - (@bar_height / 2.0),
            z: 3,
            height: @bar_height,
            width: @bar_height / 6.25
        )
        @black_bar.remove

        @yellow_bar = Image.new(
            'grejer/powermeter_fg.png',
            x: 14,
            y: (Window.height / 2.0) - (@bar_height / 2.0),
            height: @bar_height,
            z: 2,
            width: (@bar_height / 6.25) - 8
        )
        @yellow_bar.remove

        @big_black_bar = Image.new(
            'grejer/powermeter_bg.png',
            x: 10,
            y: (Window.height / 2.0) - (@bar_height / 2.0),
            z: 1,
            height: @bar_height,
            width: @bar_height / 6.25
        )
        @big_black_bar.remove

        text_power_size = 20

        @text_power = Text.new(
            @text_cool,
            x: 8,
            y: (Window.height / 2.0) - (@bar_height / 2) - (text_power_size),
            font: 'grejer/text.ttf',
            size: text_power_size,
            style: 'bold',
            color: 'black',
            z: 0
        )

        @text_power.remove

        @text_shot_1 = Text.new(
            0,
            x: 105,
            y: -10,
            font: 'grejer/text.ttf',
            size: text_power_size * 3,
            color: 'yellow',
            z: 3
        )

        @text_shot_2 = Text.new(
            0,
            x: 947,
            y: -10,
            font: 'grejer/text.ttf',
            size: text_power_size * 3,
            color: 'blue',
            z: 3
        )

        @start_screen = Image.new(
            'grejer/start.webp',
            x: 0,
            y: 0,
            z: 10000000000,
            height: Window.height,
            width: Window.width
        )
        
    end

end

#klassen för alla block
class Blocks

    attr_reader :block, :block_bg

    def initialize(level, i, j)
        size = 150.0

        if level == 1

            @block = Image.new(
                'grejer/block.png',
                x: i,
                y: (Window.height / 2.0) - (size / 2.0),
                z: 2,
                height: size,
                width: size,
            )
            @block_bg = Image.new(
                'grejer/block_bg.png',
                x: i,
                y: (Window.height / 2.0) - (size / 2.0),
                z: 1,
                height: size * 1.046875,
                width: size
            )
        elsif level == 2
            @block = Image.new(
                'grejer/block.png',
                x: i,
                y: j,
                z: 2,
                height: size,
                width: size,
            )
            @block_bg = Image.new(
                'grejer/block_bg.png',
                x: i,
                y: j,
                z: 1,
                height: size * 1.046875,
                width: size,
            ) 
        elsif level == 3
            @block = Image.new(
                'grejer/block.png',
                x: i,
                y: j,
                z: 2,
                height: size,
                width: size,
            )
            @block_bg = Image.new(
                'grejer/block_bg.png',
                x: i,
                y: j,
                z: 1,
                height: size * 1.046875,
                width: size,
            ) 
        end
    end

end

#startar igång allt
game = Game.new(@change_in_size_ball, @ball_radius)
player1 = Player.new(100.0, "yellow", @change_in_size_ball, @ball_radius)
player2 = Player.new(991.0, "blue", @change_in_size_ball, @ball_radius)

i = (Window.width / 22.0)

@block_array = [
    Blocks.new(@level, i + (Window.width / 22.0), nil),
    Blocks.new(@level, i + (Window.width / 22.0)*6.0, nil),
    Blocks.new(@level, i + (Window.width / 22.0)*11.0, nil),
    Blocks.new(@level, i + (Window.width / 22.0)*16.0, nil)
]

#när man trycker på musen
on :mouse_down do |event|

    #tar bort start skärmen
    if @start_bol == true
        @game_started = true
        game.start_screen.remove
        @start_bol = false
    end

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
        player1.arrow.y = (player1.golfboll.y - ( 63.0 * @change_in_size_ball))
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
        player2.arrow.y = (player2.golfboll.y - ( 63.0 * @change_in_size_ball))
        player2.arrow.add

        @mouse_down_on_ball_2 = true

    end

    #restartar hela spelet om man klickar på en restart knapp på sista leveln
    if @end_game == true
        if @restart_button_0.contains?(event.x, event.y)
            reset_whole_game(game, player1, player2)
        end
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
        @speed_2 = (Math.sqrt(change_in_x **2.0 + change_in_y ** 2.0)) / 8.0
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
    if @game_started == true 
        
        #hur mycket power man har och vad som visas då
        if @mouse_down_on_ball_1 == true
            @cool = (Math.sqrt((@boll_position_x - Window.mouse_x.to_f) **2.0 + (@boll_position_y - Window.mouse_y.to_f) ** 2.0)) / (8.0 / (game.bar_height / @maxspeed))
            
            if @cool + 10 < game.bar_height
                game.yellow_bar.y = ((Window.height / 2) + ((game.bar_height - 10) / 2.0)) - @cool
                game.yellow_bar.height = @cool
                @text_cool = ((@cool + 10) / game.bar_height).round(2)
                @text_cool = @text_cool * 100
                game.text_power.text = "#{@text_cool.to_i}%"
            else 
                game.yellow_bar.y = game.yellow_bar.y = ((Window.height / 2.0) + ((game.bar_height - 10) / 2.0)) - (game.bar_height - 10)
                game.yellow_bar.height = game.bar_height - 10
                game.text_power.text ="100%"

            end

            #var pilen är och pekar för boll 1
            old_angle = 180.0
            if @speed_1 == 0
                current_x = Window.mouse_x.to_f
                current_y = Window.mouse_y.to_f
                
                change_in_x = @boll_position_x - current_x
                change_in_y = @boll_position_y - current_y 

                arc_tangent = Math.atan2(change_in_x, change_in_y)
                arc_tangent_degrees = arc_tangent * (180.0 / Math::PI)
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
                @text_cool = @text_cool * 100
                game.text_power.text = "#{@text_cool.to_i}%"
            else 
                game.yellow_bar.y = game.yellow_bar.y = ((Window.height / 2) + ((game.bar_height - 10) / 2)) - (game.bar_height - 10)
                game.yellow_bar.height = game.bar_height - 10
                game.text_power.text ="100%"

            end

            #var pilen är och pekar för boll 2
            old_angle = 180.0
            if @speed_2 == 0
                current_x = Window.mouse_x.to_f
                current_y = Window.mouse_y.to_f
                
                change_in_x = @boll_position_x - current_x
                change_in_y = @boll_position_y - current_y 

                arc_tangent = Math.atan2(change_in_x, change_in_y)
                arc_tangent_degrees = arc_tangent * (180.0 / Math::PI)
                arc_tangent_degrees = -arc_tangent_degrees

                player2.arrow.rotate = old_angle + arc_tangent_degrees
                old_angle = player2.arrow.rotate
            end

        end

        #om man träffar hålet
        if game.hole.contains? player1.golfboll.x + @ball_radius, player1.golfboll.y + @ball_radius
            @speed_1 = 0
            player1.golfboll.x = 10000
            player1.golfboll.remove
            player1.golfboll_skugga.remove
            in_hole(game, player1, player2)
        end
        if game.hole.contains? player2.golfboll.x + @ball_radius, player2.golfboll.y + @ball_radius
            @speed_2 = 0
            player2.golfboll.x = 10000
            player2.golfboll.remove
            player2.golfboll_skugga.remove
            in_hole(game, player1, player2)

        end

        #nuddar vägg?
        for i in 0..36 do

            #nuddar väggen ska bollen byta rikting
            radian = ((i *10) * Math::PI) / 180 
            cos = Math.cos(radian) * 12.5
            sin =  Math.sin(radian) * 12.5
            
            x_player_1 = player1.golfboll.x + @ball_radius
            y_player_1 = player1.golfboll.y + @ball_radius  

            x_player_2 = player2.golfboll.x + @ball_radius
            y_player_2 = player2.golfboll.y + @ball_radius

            if x_player_1 - cos > Window.width
                @speed_x_1 = -@speed_x_1
                player1.golfboll.x -= 6
                player1.golfboll_skugga.x -= 6

            elsif x_player_1 + cos < 0
                @speed_x_1 = -@speed_x_1
                player1.golfboll.x += 6
                player1.golfboll_skugga.x += 6
            end
            if y_player_1 - sin > Window.height
                @speed_y_1 = -@speed_y_1
                player1.golfboll.y -= 6
                player1.golfboll_skugga.y -= 6

            elsif y_player_1 + sin < 0
                @speed_y_1 = -@speed_y_1
                player1.golfboll.y += 6
                player1.golfboll_skugga.y += 6
            end
            if x_player_2 - cos > Window.width
                @speed_x_2 = -@speed_x_2
                player2.golfboll.x -= 6
                player2.golfboll_skugga.x -= 6

            elsif x_player_2 + cos < 0
                @speed_x_2 = -@speed_x_2
                player2.golfboll.x += 6
                player2.golfboll_skugga.x += 6
            end
            if y_player_2 - sin > Window.height
                @speed_y_2 = -@speed_y_2
                player2.golfboll.y -= 6
                player2.golfboll_skugga.y -= 6

            elsif y_player_2 + sin < 0
                @speed_y_2 = -@speed_y_2
                player2.golfboll.y += 6
                player2.golfboll_skugga.y += 6
            end
        end

        #nuddar block ska bollen byta rikting
        @block_array.each do |blocks|

            if blocks.block.contains? player1.golfboll.x, player1.golfboll.y + @ball_radius or blocks.block.contains? player1.golfboll.x + (@ball_radius * 2), player1.golfboll.y + @ball_radius 
               @speed_x_1 = -@speed_x_1
            end
            if blocks.block.contains? player1.golfboll.x + @ball_radius, player1.golfboll.y or blocks.block.contains? player1.golfboll.x + @ball_radius, player1.golfboll.y + (@ball_radius * 2)
               @speed_y_1 = -@speed_y_1
            end
            if blocks.block.contains? player2.golfboll.x + @ball_radius, player2.golfboll.y or blocks.block.contains? player2.golfboll.x + @ball_radius, player2.golfboll.y + (@ball_radius * 2)
               @speed_y_2 = -@speed_y_2
            end
            if blocks.block.contains? player2.golfboll.x, player2.golfboll.y + @ball_radius or blocks.block.contains? player2.golfboll.x + (@ball_radius * 2), player2.golfboll.y + @ball_radius 
               @speed_x_2 = -@speed_x_2
            end

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

    #om bollen nuddar hålet startas denna funktion 
    def in_hole(game, player1, player2)

        HOLE.play
    
        @level_counter += 1
        if @level_counter == 2
            @level += 1
            case @level
                #beroende på level startas en ny level
            when 2
                level2(game, player1, player2)
            when 3
                level3(game, player1, player2)
            when 4
                level4(game, player1, player2)
            end
        end
    end
    
    #level 2 körs
    def level2(game, player1, player2)
        
        @block_array.each do |block|
            block.block_bg.remove
            block.block.remove
        end

        i = (Window.width / 22.0)
        j = (Window.height / 15.0)

        @block_array = [
            Blocks.new(@level, 3.0*i, 3.0*j),
            Blocks.new(@level, 3.0*i, 9.0*j),

            Blocks.new(@level, 9.5*i, 6.0*j),

            Blocks.new(@level, 16.0*i, 3.0*j),
            Blocks.new(@level, 16.0*i, 9.0*j),

        ]
        
        @total_shot_1 = @shot_1
        @total_shot_2 = @shot_2
    
        @shot_2 = 0
        @shot_1 = 0

        game.text_shot_1.text = "#{@shot_1}"
        game.text_shot_2.text = "#{@shot_2}"

        game.hole.x = (Window.width / (22.0/20.0))
        game.hole.y = ((Window.height / 2.0) - (game.hole_size / 2.0))

        player1.golfboll.add
        player1.golfboll_skugga.add
        player1.golfboll.x = (Window.width / (22 / 1.5)) - @ball_radius
        player1.golfboll.y = (Window.height / (10.0/3.0)) - @ball_radius
        player1.golfboll_skugga.x = (Window.width / (22 / 1.5)) - @ball_radius
        player1.golfboll_skugga.y = (Window.height / (10.0/3.0)) - @ball_radius +6

        player2.golfboll.add
        player2.golfboll_skugga.add
        player2.golfboll.x = (Window.width / (22 / 1.5)) - @ball_radius
        player2.golfboll.y = (Window.height / (15.0/10.5)) - @ball_radius
        player2.golfboll_skugga.x = (Window.width / (22 / 1.5)) - @ball_radius
        player2.golfboll_skugga.y = (Window.height / (15.0/10.5)) - @ball_radius + 6

        @level_counter = 0

    end

    #level 3 körs
    def level3(game, player1, player2)

        @block_array.each do |block|
            block.block_bg.remove
            block.block.remove
        end
    
        i = (Window.width / 22.0)
        j = (Window.height / 15.0)    
        @block_array = [
            Blocks.new(@level, 7.5*i, 8*j),
            Blocks.new(@level, 7.5*i, 4*j),
            Blocks.new(@level, 11.5*i, 4*j),
            Blocks.new(@level, 11.5*i, 8*j),

            Blocks.new(@level, 9.5*i, 12*j),
            Blocks.new(@level, 3.0*i, 6*j),
            Blocks.new(@level, 16.0*i, 6*j),
            Blocks.new(@level, 9.5*i, 0*j),
        ]
    
        @total_shot_1 += @shot_1
        @total_shot_2 += @shot_2
    
        @shot_2 = 0
        @shot_1 = 0
    
        game.text_shot_1.text = "#{@shot_1}"
        game.text_shot_2.text = "#{@shot_2}"
    
        game.hole.x = (Window.width / (22.0/10.5))
        game.hole.y = ((Window.height / 2.0) - (game.hole_size / 2.0))

        player1.golfboll.add
        player1.golfboll_skugga.add 
        player1.golfboll.x = (Window.width / (22.0/1.5)) - @ball_radius
        player1.golfboll.y = (Window.height / 2) - @ball_radius
        player1.golfboll_skugga.x = (Window.width / (22.0/1.5)) - @ball_radius
        player1.golfboll_skugga.y = (Window.height / 2) - @ball_radius + 6
    
        player2.golfboll.add
        player2.golfboll_skugga.add
        player2.golfboll.x = (Window.width / (22.0/20.5)) - @ball_radius
        player2.golfboll.y = (Window.height / 2) - @ball_radius
        player2.golfboll_skugga.x = (Window.width / (22.0/20.5)) - @ball_radius
        player2.golfboll_skugga.y = (Window.height / 2) - @ball_radius + 6
    
        @level_counter = 0

    
    end

    #level 4 körs
    def level4(game, player1, player2)

        @end_game = true

        @restart_button_0 = Image.new('grejer/restart.png',  width: 47, height: 47, x: 2, y: 2, z:1)

        @total_shot_1 += @shot_1
        @total_shot_2 += @shot_2

        @shot_1 = 0
        @shot_2 = 0

        game.text_shot_1.text = "#{@shot_1}"
        game.text_shot_2.text = "#{@shot_2}"

        game.hole.remove
        @block_array.each do |block|
            block.block_bg.remove
            block.block.remove
        end

        game.text_shot_1.remove
        game.text_shot_2.remove

        text_size_end_2 = 50.0

        @text_1 = Text.new(
            "Player one = #{@total_shot_1} strokes",
            x: (Window.width / (22.0/7.0)),
            y: (Window.height / 2.0) - (text_size_end_2) - 28,
            font: 'grejer/text.ttf',
            size: text_size_end_2,
            color: 'black',
            z: 1
        )
        @text_2 = Text.new(
            "Player two = #{@total_shot_2} strokes",
            x: (Window.width / (22.0/7.0)),
            y: (Window.height / 2.0) - 28,
            font: 'grejer/text.ttf',
            size: text_size_end_2,
            color: 'black',
            z: 1
        )

        if @total_shot_1 < @total_shot_2
            @winner = "player one"
        elsif @total_shot_1 > @total_shot_2
            @winner = "player two"
        else
            @winner = "Tie"
        end

        @text_3 = Text.new(
            "Winner = #{@winner}",
            x: (Window.width / (22.0/7.0)),
            y: (Window.height / 2.0) + (text_size_end_2) - 28,
            font: 'grejer/text.ttf',
            size: text_size_end_2,
            color: 'black',
            z: 1
        )

        @level_counter = 0

    end

    #resetar hela spelet om man klarat det
    def reset_whole_game(game, player1, player2)

        @end_game = false

        @text_1.remove
        @text_2.remove
        @text_3.remove

        @restart_button_0.remove

        @level = 1

        game.hole.x = (Window.width / 2.0) - (game.hole_size / 2.0)
        game.hole.y = ((Window.height / 5.0) - (game.hole_size / 2.0))

        player1.golfboll.x = 100 - @ball_radius
        player1.golfboll.y = Window.height - (Window.height / 5.0) - @ball_radius
        player1.golfboll_skugga.x = 100 - @ball_radius
        player1.golfboll_skugga.y = Window.height - (Window.height / 5.0) - @ball_radius + 6
    
        player2.golfboll.x = 991 - @ball_radius
        player2.golfboll.y = Window.height - (Window.height / 5.0) - @ball_radius
        player2.golfboll_skugga.x = 991 - @ball_radius
        player2.golfboll_skugga.y = Window.height - (Window.height / 5.0) - @ball_radius + 6

        player1.golfboll.add
        player2.golfboll.add
        player1.golfboll_skugga.add
        player2.golfboll_skugga.add

        game.hole.add

        game.text_shot_1.add
        game.text_shot_2.add

        i = (Window.width / 22.0)

        @block_array = [
            Blocks.new(@level, i + (Window.width / 22.0), nil),
            Blocks.new(@level, i + (Window.width / 22.0)*6.0, nil),
            Blocks.new(@level, i + (Window.width / 22.0)*11.0, nil),
            Blocks.new(@level, i + (Window.width / 22.0)*16.0, nil)
        ]

    end

end
 
show