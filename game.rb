require 'ruby2d'

set width: 1200
set height: 745
@speed_x = 0.0
@speed_y = 0.0
@speed = 0.0
@bob = 1
@bob2 = 1
@boll_position_y = 0
@boll_position_x = 0

class Game

    attr_reader :golfboll, :ball_radius, :arrow

    def initialize

        @ball_radius = 12

        @bg = Image.new('bg.png')
        @golfboll = Sprite.new(
        'ball.png',
        x: (Window.width / 2) - @ball_radius,
        y: Window.height - 135.454545455 - @ball_radius,
        width: @ball_radius * 2,
        height: @ball_radius * 2,
        z: 2
        )

        @arrow = Sprite.new(
            'point1.png',
            x: (Window.width / 2) - 12.5,
            y: Window.height - 135.454545455 - 60,
            width: 24,
            height: 120,
            rotate: 180,
            z: 1
        )
        @arrow.remove
    end

end

game = Game.new

on :mouse_down do |event|

    @boll_position_x = event.x.to_f
    @boll_position_y = event.y.to_f

    if game.golfboll.contains? @boll_position_x, @boll_position_y and @speed == 0

        game.arrow.add

        game.arrow.x = game.golfboll.x
        game.arrow.y = game.golfboll.y - 48

        @boll_position_x = game.golfboll.x.to_f + game.ball_radius
        @boll_position_y = game.golfboll.y.to_f + game.ball_radius
        
    end
end

on :mouse_up do |event|

    current_x = event.x.to_f
    current_y = event.y.to_f

    change_in_x = @boll_position_x - current_x
    change_in_y = @boll_position_y - current_y   

    if game.golfboll.contains? @boll_position_x, @boll_position_y and @speed == 0

        game.arrow.remove

        #sätter farten
        @speed = (Math.sqrt(change_in_x **2 + change_in_y ** 2)) / 8
        @speed_x = @speed
        @speed_y = @speed

        #max fart
        if @speed > 15
            @speed = 15
        end
        if @speed_y > 15
            @speed_y = 15
        end

        #sätter rikitningne på bollen
        if change_in_x < 0 
            @speed_x = -@speed_x
        end
        if change_in_y < 0 
            @speed_y = -@speed_y
        end

        #skilnnaden i sidled. detta är fel just nu
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

    #utanför skärmen ska den byta håll
    if game.golfboll.x < 0 or game.golfboll.x > (Window.width - game.golfboll.width) 
        @speed_x = -@speed_x
    elsif game.golfboll.y < 0 or game.golfboll.y > (Window.height - game.golfboll.width)
        @speed_y = -@speed_y
    end

    #friktion
    if @speed.abs > 0.5
        @speed = @speed * 0.98
        @speed_x = @speed_x * 0.98
        @speed_y = @speed_y * 0.98
    elsif @speed.abs <= 0.5 && @speed.abs > 0.05
        @speed = @speed * 0.98
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

    p @speed
end

show