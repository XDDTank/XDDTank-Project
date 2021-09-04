package consortion.view.monsterReflash
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import worldboss.player.RankingPersonInfo;
   import worldboss.view.RankingPersonInfoItem;
   
   public class ConsortionMonsterRankFrame extends BaseAlerFrame
   {
      
      public static var _rankingPersons:Array = new Array();
       
      
      private var titleLineBg:MutipleImage;
      
      private var titleBg:MutipleImage;
      
      private var numTitle:FilterFrameText;
      
      private var nameTitle:FilterFrameText;
      
      private var souceTitle:FilterFrameText;
      
      private var _sureBtn:TextButton;
      
      public function ConsortionMonsterRankFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("consortion.totalInfo.frameTitle");
         this.titleBg = ComponentFactory.Instance.creatComponentByStylename("worldboss.RankingFrame.RankingTitleBg");
         addToContent(this.titleBg);
         this.titleLineBg = ComponentFactory.Instance.creatComponentByStylename("worldboss.RankingItem.bgLine");
         addToContent(this.titleLineBg);
         this.numTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.numTitle");
         this.numTitle.text = LanguageMgr.GetTranslation("worldboss.ranking.num");
         addToContent(this.numTitle);
         this.nameTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.nameTitle");
         this.nameTitle.text = LanguageMgr.GetTranslation("worldboss.ranking.name");
         addToContent(this.nameTitle);
         this.souceTitle = ComponentFactory.Instance.creatComponentByStylename("worldboss.ranking.souceTitle");
         this.souceTitle.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text");
         addToContent(this.souceTitle);
         this._sureBtn = ComponentFactory.Instance.creat("worldboss.ranking.btn");
         this._sureBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         addToContent(this._sureBtn);
         this._sureBtn.addEventListener(MouseEvent.CLICK,this.__sureBtnClick);
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
      }
      
      private function testRanking() : void
      {
         var _loc2_:RankingPersonInfo = null;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = new RankingPersonInfo();
            _loc2_.id = _loc1_;
            _loc2_.damage = 20 * _loc1_;
            _loc2_.name = "danny" + _loc1_;
            _loc2_.isVip = _loc1_ % 2 == 0 ? Boolean(true) : Boolean(false);
            this.addPersonRanking(_loc2_);
            _loc1_++;
         }
      }
      
      public function addPersonRanking(param1:RankingPersonInfo) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Boolean = false;
         if(_rankingPersons.length == 0)
         {
            _rankingPersons.push(param1);
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < _rankingPersons.length)
            {
               if((_rankingPersons[_loc3_] as RankingPersonInfo).damage < param1.damage)
               {
                  _rankingPersons.splice(_loc3_,0,param1);
                  return;
               }
               _loc3_++;
            }
            _rankingPersons.push(param1);
         }
      }
      
      public function show() : void
      {
         var _loc2_:int = 0;
         var _loc3_:RankingPersonInfoItem = null;
         var _loc1_:Point = ComponentFactory.Instance.creat("worldBoss.ranking.itemPos");
         _loc2_ = 0;
         while(_loc2_ < _rankingPersons.length)
         {
            _loc3_ = new RankingPersonInfoItem(_loc2_ + 1,_rankingPersons[_loc2_] as RankingPersonInfo);
            _loc3_.x = _loc1_.x;
            _loc3_.y = _loc1_.y * (_loc2_ + 1) + 60;
            addChild(_loc3_);
            _loc2_++;
         }
         LayerManager.Instance.addToLayer(this,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      private function __sureBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         var _loc1_:int = 0;
         while(_loc1_ < _rankingPersons.length)
         {
            _rankingPersons.shift();
         }
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
