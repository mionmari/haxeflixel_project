package;

import flixel.FlxState;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import GlobalValues;

class ShowEnemySubState extends FlxSubState {
    /*
    0 -- nothing
    1 -- human type 1
    2 -- human type 2
    */
    public static var enemyBoard:Array<Array<Int>>;

    // Buttons variables
    private var returnToDeploymentButton:FlxButton;
    // End variables

    // Board variables
    private var boardSprite:Array<Array<Tile>>;
    private var entitySprite:Array<Array<FlxSprite>>;
    private var boardUpperLeftX:Float = FlxG.width * 0.5;
    private var boardUpperLeftY:Float = FlxG.height * 0.37;
    // End variables

    private var levelData:LevelData;

    override public function create():Void {
        super.create();
        initBackground();
        initBoardArea();
        initButtons();
    }

    public function updateLevelData(newLevelData:LevelData) {
        levelData = newLevelData;
    }

    function initBackground():Void{
        var background = new FlxSprite(0,20);
        background.alpha = 0.7;
		background.loadGraphic("assets/images/NECROBG.png");
		add(background);
    }

    private function initBoardArea():Void {
        boardSprite = new Array<Array<Tile>>();
        for (j in 0...GlobalValues.HUMAN_HEIGHT) {
            boardSprite[j] = new Array<Tile>();
            for (i in 0...GlobalValues.HUMAN_WIDTH) {
                boardSprite[j].push(new Tile(levelData.getTilePath()));
                boardSprite[j][i].setPosition(boardUpperLeftX + i * boardSprite[j][i].width, boardUpperLeftY + j * boardSprite[j][i].height);
                add(boardSprite[j][i]);
            }
        }
    }

    private function initButtons():Void {
        returnToDeploymentButton = new FlxButton(0, 0, "Return", returnToDeployment);
        returnToDeploymentButton.scale.set(1.2,4.2);
        returnToDeploymentButton.updateHitbox();

        returnToDeploymentButton.label.fieldWidth = returnToDeploymentButton.width;
        returnToDeploymentButton.label.alignment = "center";

        returnToDeploymentButton.label.size = 14;
        returnToDeploymentButton.label.offset.y -= 28;

        returnToDeploymentButton.x = FlxG.width * 0.9;
        returnToDeploymentButton.y = FlxG.height * 0.38;
        add(returnToDeploymentButton);
    }

    private function returnToDeployment():Void {
        close();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}