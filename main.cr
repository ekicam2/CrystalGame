require "./lib/crsfml"

#A rpg where you go to school with pixies(wróżka) in the kingdom.

module EK

    enum State
        MainMenu
        Paused
        Running
        Finished
    end

    class Scene
        def initialize(@name, window : SF::RenderWindow*)
            @window.value
        end

        def run(State) : Int
        end
    end
    
    class TextureManager
        def initialize
            @textureContainer = Array(SF::Texture).new
        end

        def addTexture(path : String)
            @textureContainer << SF::Texture.from_file(path);
        end

        def getTexture(id : Int) : SF::Texture
            @textureContainer.at(id)
        end
    
        def deleteTexture(id : Int64)
            @textureContainer.delete_at(id)
        end

    end

    class SceneManager
        def initialize
            @SceneContainer = Array(Scene).new
            @CurrentScene = 0
        end
        
        def addScene(scene : Scene)
            @SceneContainer << scene
        end

        def getScene(id : Int) : Scene
            @SceneContainer[id]
        end
        
        def setCurrentScene(id : Int) : Int
            @CurrentScene = id
        end

        def getCurrentScene : Int
            @CurrentScene
        end

    end

    class StateManager
        def initlize(@CurrentState : State)
        end
        
        def setState(@CurrentState : State)
        end

        def getState : State
            @CurrentState
        end
end

class Menu <  EK::Scene
    def initialize(name, window)
        super(name, window)
        @Font = SF::Font.from_file("./res/fonts/comicate.ttf")
        @Label1 = SF::Text.new("lololo", @Font)
    end

    def run : Int
        while event = @Window.poll_event
            case event.type

                when SF::Event::Closed
                    @Window.close

                when SF::Event::KeyPressed
                    case event.key.code
                        when SF::Keyboard::Return
                           return 1 
                    end
            end
        end

        @Window.clear(SF::Color::Red)

        #draw
        @Window.draw(@Label1)
        
        @Window.display
        return 0
    end
end

class FirstScene < EK::Scene
    def initialize(name, window)
        super(name, window)
        @TextureManager = EK::TextureManager.new
        @TextureManager.addTexture("./Spritesheet/RPGpack_sheet.png")
        @Shape = SF::CircleShape.new(150)
        @Shape.set_texture(@TextureManager.getTexture(0), false)
    end

    def run : Int
        while event = @Window.poll_event
            case event.type

                when SF::Event::Closed
                    @Window.close

                when SF::Event::KeyPressed
                    case event.key.code
                        when SF::Keyboard::Left
                            @Shape.move(SF::Vector2.new(-20, 0))
                        
                        when SF::Keyboard::Right
                            @Shape.move(SF::Vector2.new(20, 0))
                    end    
            end

        end

        #logic

        @Window.clear(SF::Color::Red)

        #draw
        @Window.draw(@Shape)
        
        @Window.display
        
        return 1 #return
    end

end

#kinda globals
window = SF::RenderWindow.new(SF.video_mode(800, 600), "Turbo Game")
sceneManager = EK::SceneManager.new

#main loop
scene = FirstScene.new("pierwsza", pointerof(window))
menu = Menu.new("menu", pointerof(window))

sceneManager = EK::SceneManager.new
sceneManager.addScene(menu)
sceneManager.addScene(scene)

while window.open?

    helper = sceneManager.getScene(sceneManager.getCurrentScene).run

    sceneManager.setCurrentScene(helper)

end
