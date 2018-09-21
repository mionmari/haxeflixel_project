package;

import flixel.FlxState;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import GlobalValues;


class DeploymentState extends FlxState
{
    /*
    Deployed Board will be an array of integers.
    0 -- nothing
    1 -- zombie
    */

	private var _deployMenu : DeploymentMenu;
	private var showEnemyButton:FlxButton;

    private var deploymentSpriteGroups:Array<FlxTypedGroup<FlxSprite>>;
    private var deploymentSprites:Array<Array<FlxSprite>>;

    // Deployment area variables
    private var boardSprite:Array<Array<Tile>>;
    public var boardDeployment:Array<Array<Int>>;
    private var deploymentBoardUpperLeftX:Float = FlxG.width * 0.3;
    private var deploymentBoardUpperLeftY:Float = FlxG.height * 0.2;

    // End variables

	override public function create():Void
	{
        _deployMenu = new DeploymentMenu();
        add(_deployMenu);
        initDeploymentArea();
		initShowEnemyButton();
		super.create();
	}

	private function initShowEnemyButton():Void {
        showEnemyButton = new FlxButton(FlxG.width * 0.8, FlxG.height * 0.8, "Show Enemy", showEnemy);
        showEnemyButton.updateHitbox();
        showEnemyButton.label.alignment = "center";
        add(showEnemyButton);
    }

	private function showEnemy():Void {
        openSubState(new ShowEnemySubState(0xff000000));
    }

    // Initialize the board sprite array
    // Initialize the array that record the deployment result
    private function initDeploymentArea():Void {
        deploymentSpriteGroups = new Array<FlxTypedGroup<FlxSprite>>();
        deploymentSprites = new Array<Array<FlxSprite>>();
        boardSprite = new Array<Array<Tile>>();
        boardDeployment = new Array<Array<Int>>();
        for (j in 0...GlobalValues.DEPLOYMENT_HEIGHT) {
            deploymentSpriteGroups.push(new FlxTypedGroup<FlxSprite>());
            boardSprite.push(new Array<Tile>());
            boardDeployment.push(new Array<Int>());
            deploymentSprites.push(new Array<FlxSprite>());
            for (i in 0...GlobalValues.DEPLOYMENT_WIDTH) {
                boardSprite[j].push(new Tile());
                boardDeployment[j].push(0);
                boardSprite[j][i].setPosition(deploymentBoardUpperLeftX + i * boardSprite[j][i].width, deploymentBoardUpperLeftY + j * boardSprite[j][i].height);
                add(boardSprite[j][i]);
                deploymentSprites[j].push(new FlxSprite());
            }
            add(deploymentSpriteGroups[j]);
        }
    }

    // After mouse released in (X, Y), this function will be call
    // Record the deplyment to the array
    private function deploy(x:Float, y:Float) {
        for (j in 0...GlobalValues.DEPLOYMENT_HEIGHT) {
            for (i in 0...GlobalValues.DEPLOYMENT_WIDTH) {
                var minX = deploymentBoardUpperLeftX + i * boardSprite[j][i].width;
                var minY = deploymentBoardUpperLeftY + j * boardSprite[j][i].height;
                var maxX = minX + boardSprite[j][i].width;
                var maxY = minY + boardSprite[j][i].height;
                if (x >= minX && x < maxX && y >= minY && y < maxY) {
                    if (boardDeployment[j][i] == _deployMenu.mouseSelectedTarget) return;
                    if (boardDeployment[j][i] != 0 && boardDeployment[j][i] != _deployMenu.mouseSelectedTarget) deploymentSpriteGroups[j].remove(deploymentSprites[j][i]);
                    var sprite = new FlxSprite();
                    if (_deployMenu.mouseSelectedTarget == 1) sprite.loadGraphic("assets/images/Zombie.png");
                    else if (_deployMenu.mouseSelectedTarget == 2) sprite.loadGraphic("assets/images/Skeleton.png");
                    sprite.setPosition(minX + sprite.width * 0.15, minY - sprite.height * 0.6);
                    deploymentSpriteGroups[j].add(sprite);
                    deploymentSprites[j][i] = sprite;
                    boardDeployment[j][i] = _deployMenu.mouseSelectedTarget;
                    break;
                }
            }
        }
        SimulationState.deploymentUnits = boardDeployment;
    }

    private function cancelDeploy(x:Float, y:Float) {
        for (j in 0...GlobalValues.DEPLOYMENT_HEIGHT) {
            for (i in 0...GlobalValues.DEPLOYMENT_WIDTH) {
                var minX = deploymentBoardUpperLeftX + i * boardSprite[j][i].width;
                var minY = deploymentBoardUpperLeftY + j * boardSprite[j][i].height;
                var maxX = minX + boardSprite[j][i].width;
                var maxY = minY + boardSprite[j][i].height;
                if (x >= minX && x < maxX && y >= minY && y < maxY) {
                    if (boardDeployment[j][i] == 0) return;
                    boardDeployment[j][i] = 0;
                    deploymentSpriteGroups[j].remove(deploymentSprites[j][i]);
                    deploymentSprites[j][i] = new FlxSprite();
                }
            }
        }
    }

    // When update frames, check the mouse status and call deploy if necessary
	override public function update(elapsed:Float):Void
	{
        if (_deployMenu.mouseSelectedTarget != 0) {
            // Right click to cancel
            if (FlxG.mouse.pressedRight) {
                FlxG.mouse.unload();
                _deployMenu.mouseSelectedTarget = 0;
            // Left click to deploy
            } else if (FlxG.mouse.justPressed) {
                deploy(FlxG.mouse.x, FlxG.mouse.y);
                FlxG.mouse.unload();
                _deployMenu.mouseSelectedTarget = 0;
            }
        } else {
            if (FlxG.mouse.pressedRight) cancelDeploy(FlxG.mouse.x, FlxG.mouse.y);
        }
		super.update(elapsed);
	}
}
