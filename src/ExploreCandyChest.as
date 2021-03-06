package
{
	import flash.geom.Point;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	
	public class ExploreCandyChest extends FlxSprite
	{
		private var isEnabled:Boolean = true;
		private const maxEnemiesAttacking:Number = 2;
		public var enemySlotsOccupied:Boolean = false;
		
		private const occupyDistance:Number = 80;
		
		private const healthGain:int = BalanceHooks.healthGain;
		
		private var _enemies:FlxGroup;
		private var _chests:FlxGroup;
		private var _inGameMessage:FlxText;
		private var boundingBoxReduction:Number = 18;
		
		public function ExploreCandyChest(X:Number, Y:Number, chests:FlxGroup, enemies:FlxGroup, inGameMessage:FlxText) {
			super(X, Y, null);
			_enemies = enemies;
			_chests = chests;
			_inGameMessage = inGameMessage;
			loadGraphic(Sources.TreasureChest, true, false, 40, 40);
			height -= boundingBoxReduction; 
			width -= boundingBoxReduction;
			offset.x = boundingBoxReduction/2.0;
			offset.y = boundingBoxReduction/2.0;
			//FlxG.visualDebug = true;
			addAnimation("open", [1]); 
			immovable = true;
		}
		
		private function giveCandy():void {
			var candies:Array = [Inventory.COLOR_RED, Inventory.COLOR_BLUE, Inventory.COLOR_WHITE];
			var reward:int = int(FlxG.getRandom(candies));
			var color:String = ["red", "blue", "white"][reward];
			Inventory.addCandy(reward);
			showMessage("You got a " + color + " candy!");
		}
		
		private function giveMaxHealth():void {
			FlxG.play(Sources.maxHealth);
			PlayerData.instance.maxHealth += healthGain;
			PlayerData.instance.currentHealth += healthGain;
			showMessage("You gained " + healthGain.toString() + " max health!");
		}
		
		public function rewardTreasure():void {
			if (isEnabled) {
				//select reward
				var rewardFunctions:Array = [giveCandy, giveMaxHealth];
				var choice:Function = FlxG.getRandom(rewardFunctions) as Function;
				choice.call();
				play("open");
				FlxG.play(Sources.treasure);
				isEnabled = false;
				var timer:FlxTimer = new FlxTimer(); 
				var that:FlxBasic = this;
				timer.start(1,1,function(timer:FlxTimer){
					_chests.remove(that);
				});
			}
		}
		
		public function showMessage(message:String):void {	
			_inGameMessage.visible = true;
			_inGameMessage.text = message;
			var timer:FlxTimer = new FlxTimer();
			timer.start(1,1,function(timer:FlxTimer){
				_inGameMessage.visible = false;
			});
		}
		
		override public function update():void {
			//decide whether there are enough enemies close by or not
			var selfPoint:Point = new Point();
			this.getMidpoint().copyToFlash(selfPoint);
			var occupiedEnemiesCount:Number = 0;
			for each (var enemy:ExploreEnemy in _enemies.members) {
				if (enemy == null) {continue;}
				var otherPoint:Point = new Point();
				enemy.getMidpoint().copyToFlash(otherPoint);
				var vectorFromOther:Point = selfPoint.subtract(otherPoint);
				var distance:Number = vectorFromOther.length;
				if (distance < occupyDistance) {
					occupiedEnemiesCount += 1;
					if (occupiedEnemiesCount > maxEnemiesAttacking) {
						break;
					}
				}
			}
			if (occupiedEnemiesCount >= maxEnemiesAttacking) {
				enemySlotsOccupied = true;
			} else {
				enemySlotsOccupied = false;
			}
		}
	}
}