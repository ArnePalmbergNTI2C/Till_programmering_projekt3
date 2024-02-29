require 'ruby2d'

set width: 1100
set height: 745
@speed_x = 0.0
@speed_y = 0.0
@bob = 1
@bob2 = 1

class Game

    attr_reader :golfboll

    def initialize

        @ball_radius = 10

        @bg = Image.new('bg.png')
        @golfboll = Sprite.new(
        'ball.png',
        x: (Window.width / 2) - @ball_radius,
        y: Window.height - 135.454545455 - @ball_radius,
        width: @ball_radius * 2,
        height: @ball_radius * 2,
        z: 2
        )

    end

end

game = Game.new

on :mouse_down do |event|

    @boll_position_x = event.x.to_f 
    @boll_position_y = event.y.to_f

end

on :mouse_up do |event|

    current_x = event.x
    current_y = event.y

    change_in_x = @boll_position_x - current_x
    change_in_y = @boll_position_y - current_y

    @speed_x = (Math.sqrt(change_in_x **2 + change_in_y ** 2)) / 10
    p @speed_x
    if @speed_x <20
    if change_in_x < 0 
        @speed_x = -@speed_x
    end
      
    @speed_y = (Math.sqrt(change_in_x **2 + change_in_y ** 2)) / 10
    if change_in_y < 0 
        @speed_y = -@speed_y
    end

    if (change_in_x).abs > (change_in_y).abs
        @bob = (change_in_x / change_in_y).abs
        @bob2 = 1
    else
        @bob2 = (change_in_y / change_in_x).abs
        @bob = 1
    end  

end

update do

    if game.golfboll.x < 0 or game.golfboll.x > (Window.width - game.golfboll.width) 
        @speed_x = -@speed_x
    elsif game.golfboll.y < 0 or game.golfboll.y > (Window.height - game.golfboll.width)
        @speed_y = -@speed_y
    end

    game.golfboll.x += @speed_x / @bob2
    game.golfboll.y += @speed_y / @bob

    if @speed_x > 0.3
        @speed_x -= 0.1
    elsif @speed_x < -0.3
        @speed_x += 0.1
    else
        @speed_x = 0
    end

    if @speed_y > 0.3
        @speed_y -= 0.1
    elsif @speed_y < -0.3
        @speed_y += 0.1
    else
        @speed_y = 0
    end


end

show
