package {
	/**
	 * @author ethanis
	 */
	public class Weapon {
		var attack:int;
		var defense:int;
		var name:String;
		var buff:int;
		
		/*
		'buffs' is a dictionary of arrays. each key is a point at which buffs can be applied.
		for example, buffs['equip'] might contain buffs that are applied when equipping this weapon, like 'heal'
		and buffs['hit'] might contain buffs that are applied when hitting an enemy, like 'burn' and 'freeze'.
		*/
		var buffs:Object = { }; // yo nate why isn't this just the index of the buff? we only have 1 buff and they are all on-hit effects
		
		// 1-3 match Candy constants.
		public static const NO_SPECIAL:int = 0;
		public static const RED_SPECIAL:int = 1;
		public static const BLUE_SPECIAL:int = 2;
		public static const WHITE_SPECIAL:int = 3;
		public static const RR_SPECIAL:int = 4;
		public static const BB_SPECIAL:int = 5;
		public static const WW_SPECIAL:int = 6;
		public static const RB_SPECIAL:int = 7;
		public static const RW_SPECIAL:int = 8;
		public static const WB_SPECIAL:int = 9;
		
		// this might get moved later -npinsker
		public static const BUFF_LIST:Array = [ 	new Buff('none', 'none', 'none', 0, function(src:BattleCharacter, trg:BattleCharacter):void { }),
													new Buff('burn', 'Burn', 'Has a 50% chance to apply a burn on hit which damages the enemy over time.', 3, function(src:BattleCharacter, trg:BattleCharacter):void { if (Math.random() < 0.5) src.hurt(1); }),
													new Buff('freeze', 'Freeze', 'Has a chance to freeze the enemy, disabling their attack for a turn.', 1, function(src:BattleCharacter, trg:BattleCharacter):void { src.tempAttackStat = -src.attackStat; } ),
													new Buff('heal', 'Drain', 'Has a 50% chance to restore 1 point of blood sugar on hit.', -1, function(src:BattleCharacter, trg:BattleCharacter):void { if (Math.random() < 0.5) src.heal(1); }),
													new Buff('burn', 'Ignite', 'Applies a burn on hit which damages the enemy over time.', 3, function(src:BattleCharacter, trg:BattleCharacter):void { src.hurt(1); }),
													new Buff('freeze', 'Deep Freeze', 'Has a chance to freeze the enemy, disabling their attack for 2 turns.', 2, function(src:BattleCharacter, trg:BattleCharacter):void { src.tempAttackStat = -src.attackStat; }),
													new Buff('heal', 'Mega Drain', 'Restores one point of blood sugar on hit.', -1, function(src:BattleCharacter, trg:BattleCharacter):void { src.heal(1); }),
													new Buff('pierce', 'Pierce', 'Attacks with this weapon ignore the enemy\'s defense.', -1, function(src:BattleCharacter, trg:BattleCharacter):void { src.flags = ['true']; }),
													new Buff('dispel', 'Dispel', 'Attacks with this weapon remove status effects on the enemy for increased damage.', -1, function(src:BattleCharacter, trg:BattleCharacter):void { trg.hurt(2 * src.buffs.length); trg.buffs = []; }),
													new Buff('cascade', 'Cascade', 'Repeated attacks with this weapon become stronger and stronger.', -1, function(src:BattleCharacter, trg:BattleCharacter):void { })	];

		public function Weapon(name:String, attack:int=1, defense:int=0, buffs:Object = null, useDefault:Boolean = true){
			this.name = name;
			this.attack = attack;
			this.defense = defense;
			
			if (useDefault) {
				this.buff = (int)(buffs);
				this.buffs = { };
				this.buffs[Sources.defaultBuffStrings[buffs]] = buffs;
			}
			else {
				this.initializeBuffs(buffs);
			}
		}
		
		public function initializeBuffs(buffs:Object):void{
			this.buffs = buffs;
		}
		
		public function buffsOfType(type:String):Array {
			return buffs[type];
		}
		
		public function getDisplayName():String {
			if (buff == 0) {
				return name;
			}
			else {
				return name + " of " + BUFF_LIST[buff].name;
			}
		}
	}
}