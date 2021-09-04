package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import worldboss.player.RankingPersonInfo;
   
   public class WorldBossRankingView extends Component
   {
       
      
      private var _titleBg:Bitmap;
      
      private var _rankBG:MutipleImage;
      
      private var _container:Sprite;
      
      private var _horizontalArrangePos:Point;
      
      private var _horizontalObjPos:Point;
      
      public function WorldBossRankingView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._titleBg = ComponentFactory.Instance.creatBitmap("asset.worldboss.rankingTitle");
         addChild(this._titleBg);
         this._rankBG = ComponentFactory.Instance.creatComponentByStylename("worldboss.awardview.rankingBG");
         addChild(this._rankBG);
         this._horizontalArrangePos = ComponentFactory.Instance.creatCustomObject("worldboss.awardview.horizontalArrangePos");
         this._horizontalObjPos = ComponentFactory.Instance.creatCustomObject("worldboss.awardview.horizontalobjPos");
         this._container = new Sprite();
         DisplayUtils.setDisplayPos(this._container,this._horizontalObjPos);
         addChild(this._container);
      }
      
      public function set rankingInfos(param1:Vector.<RankingPersonInfo>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:RankingPersonInfo = null;
         var _loc6_:RankViewItem = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:int = 1;
         var _loc3_:int = 0;
         for each(_loc5_ in param1)
         {
            _loc6_ = new RankViewItem(_loc2_++,_loc5_);
            _loc6_.y += 32 * _loc3_;
            _loc3_++;
            this._container.addChild(_loc6_);
         }
      }
      
      override public function dispose() : void
      {
         while(this._container.numChildren > 0)
         {
            this._container.removeChildAt(0);
         }
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeObject(this._rankBG);
         this._rankBG = null;
         ObjectUtils.disposeObject(this._container);
         this._container = null;
         super.dispose();
      }
   }
}
