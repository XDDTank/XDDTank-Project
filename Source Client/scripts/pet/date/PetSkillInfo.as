package pet.date
{
   import flash.events.EventDispatcher;
   
   public class PetSkillInfo extends EventDispatcher
   {
      
      public static const BALL_TYPE_0:int = 0;
      
      public static const BALL_TYPE_1:int = 1;
      
      public static const BALL_TYPE_2:int = 2;
      
      public static const BALL_TYPE_3:int = 3;
       
      
      public var ID:int;
      
      public var Name:String;
      
      public var ElementIDs:String;
      
      public var Description:String;
      
      private var _ballType:int;
      
      public var NewBallID:int;
      
      public var CostMP:int;
      
      public var Pic:String;
      
      public var Action:String;
      
      private var _effectPic:String;
      
      public var Delay:int;
      
      public var ColdDown:int;
      
      public var GameType:int;
      
      public var Probability:int;
      
      private var _EffectDelay:int;
      
      public function PetSkillInfo()
      {
         super();
      }
      
      public function get BallType() : int
      {
         return this._ballType;
      }
      
      public function set BallType(param1:int) : void
      {
         this._ballType = param1;
      }
      
      public function get EffectPic() : String
      {
         return this._effectPic;
      }
      
      public function get EffectClassLink() : String
      {
         return "asset.game.skill.effect." + this._effectPic;
      }
      
      public function set EffectPic(param1:String) : void
      {
         this._effectPic = param1;
      }
      
      public function get isActiveSkill() : Boolean
      {
         return this.Probability == -1;
      }
      
      public function get EffectDelay() : int
      {
         return this._EffectDelay;
      }
      
      public function set EffectDelay(param1:int) : void
      {
         this._EffectDelay = param1;
      }
   }
}
