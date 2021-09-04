package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import flash.geom.Point;
   import worldboss.WorldBossRoomController;
   import worldboss.player.RankingPersonInfo;
   
   public class WorldBossAwardOptionLeftView extends Sprite implements Disposeable
   {
       
      
      private var _rankingView:WorldBossRankingView;
      
      private var _rankBG:MutipleImage;
      
      private var _rankBGPos:Point;
      
      private var arr:Vector.<RankingPersonInfo>;
      
      private var list:Vector.<RankingPersonInfo>;
      
      public function WorldBossAwardOptionLeftView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._rankBG = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankBG");
         addChild(this._rankBG);
         this._rankBGPos = ComponentFactory.Instance.creatCustomObject("asset.worldbossAwardRoom.rankBGPos");
         DisplayUtils.setDisplayPos(this._rankBG,this._rankBGPos);
         this.arr = new Vector.<RankingPersonInfo>();
         this._rankingView = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankingView");
         addChild(this._rankingView);
      }
      
      public function updateScore() : void
      {
         var _loc2_:RankingPersonInfo = null;
         if(this.arr.length > 0)
         {
            this.clear();
         }
         this.list = WorldBossRoomController.Instance._sceneModel.list;
         var _loc1_:int = 0;
         while(_loc1_ < this.list.length)
         {
            _loc2_ = new RankingPersonInfo();
            _loc2_.nickName = this.list[_loc1_].nickName;
            _loc2_.damage = 1000 + _loc1_;
            _loc2_.id = 1;
            _loc2_.userId = this.list[_loc1_].userId;
            _loc2_.isVip = this.list[_loc1_].isVip;
            _loc2_.typeVip = _loc1_ % 2 == 0 ? int(1) : int(0);
            this.arr.push(_loc2_);
            _loc1_++;
         }
         this._rankingView.rankingInfos = this.arr;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._rankBG);
         this._rankBG = null;
         ObjectUtils.disposeObject(this._rankingView);
         this._rankingView = null;
      }
      
      public function clear() : void
      {
         this.arr.length = 0;
         this.list = null;
         this._rankingView.rankingInfos = null;
      }
   }
}
