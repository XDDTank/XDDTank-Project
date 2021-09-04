package game.actions
{
   import ddt.manager.SharedManager;
   import game.objects.GamePlayer;
   import game.view.map.MapView;
   
   public class MultiPlaySpellSkillAction extends BaseAction
   {
       
      
      private var _playerList:Vector.<GamePlayer>;
      
      private var _mapView:MapView;
      
      public function MultiPlaySpellSkillAction(param1:MapView, param2:Vector.<GamePlayer>)
      {
         super();
         this._mapView = param1;
         this._playerList = param2;
      }
      
      override public function execute() : void
      {
         if(_isFinished)
         {
            return;
         }
         _isFinished = !this._mapView.isPlayingMovie;
      }
      
      override public function executeAtOnce() : void
      {
         super.executeAtOnce();
      }
      
      override public function get isFinished() : Boolean
      {
         return super.isFinished;
      }
      
      override public function prepare() : void
      {
         var _loc1_:Vector.<GamePlayer> = new Vector.<GamePlayer>();
         var _loc2_:int = 0;
         while(_loc2_ < this._playerList.length)
         {
            if((this._playerList[_loc2_].player.skill >= 0 || this._playerList[_loc2_].player.isSpecialSkill) && SharedManager.Instance.showParticle && !PrepareShootAction.hasDoSkillAnimation)
            {
               _loc1_.push(this._playerList[_loc2_]);
            }
            _loc2_++;
         }
         if(_loc1_.length > 0)
         {
            PrepareShootAction.hasDoSkillAnimation = true;
            this._mapView.playMultiSpellkill(_loc1_);
         }
         else
         {
            _isFinished = true;
         }
      }
   }
}
