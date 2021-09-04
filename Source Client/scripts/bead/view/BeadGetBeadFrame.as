package bead.view
{
   import bagAndInfo.info.MoneyInfoView;
   import baglocked.BaglockedManager;
   import bead.BeadManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.data.goods.Price;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   import store.HelpPrompt;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class BeadGetBeadFrame extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _ddtmoneyView:MoneyInfoView;
      
      private var _myScorePic:Bitmap;
      
      private var _arrow1:Image;
      
      private var _arrow2:Image;
      
      private var _arrow3:Image;
      
      private var _requestBtn1:SimpleBitmapButton;
      
      private var _requestBtn2:SimpleBitmapButton;
      
      private var _requestBtn3:SimpleBitmapButton;
      
      private var _requestBtn4:SimpleBitmapButton;
      
      private var _helpBtn:SimpleBitmapButton;
      
      private var _requestBtnCartoon:MovieClip;
      
      private var _moneyList:Array;
      
      private var _myScoreExchangeBtn:TextButton;
      
      private var _myScoreTxt:FilterFrameText;
      
      private var _beadMasterText:FilterFrameText;
      
      private var _isBuyOneKey:Boolean;
      
      public function BeadGetBeadFrame()
      {
         super();
         this._moneyList = BeadManager.instance.beadConfig.GemGold.split("|");
         this.initView();
         this.initEvent();
         this.refreshRequestBtn();
      }
      
      public function set isBuyOneKey(param1:Boolean) : void
      {
         this._isBuyOneKey = param1;
      }
      
      private function initView() : void
      {
         this._arrow1 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.arrowIcon1");
         this._arrow2 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.arrowIcon2");
         this._arrow3 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.arrowIcon3");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.beadGetBeadFrame.BgI");
         this._requestBtn1 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn1");
         this._requestBtn1.tipData = 1;
         this._requestBtn2 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn2");
         this._requestBtn2.tipData = 2;
         this._requestBtn3 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn3");
         this._requestBtn3.tipData = 3;
         this._requestBtn4 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn4");
         this._requestBtn4.tipData = 4;
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.helpBtn");
         this._myScoreExchangeBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.myScoreExchangeBtn");
         this._myScoreExchangeBtn.text = LanguageMgr.GetTranslation("beadSystem.bead.scoreShop");
         this._myScoreTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.myScoreTxt");
         this._myScorePic = ComponentFactory.Instance.creatBitmap("asset.beadSystem.myScorePic");
         this._ddtmoneyView = new MoneyInfoView(Price.GOLD);
         PositionUtils.setPos(this._ddtmoneyView,"bead.ico.goldTxtPos");
         this._beadMasterText = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadMasterText");
         this._beadMasterText.text = LanguageMgr.GetTranslation("beadSystem.bead.getBeadFrame.beadMaserText");
         addChild(this._bg);
         addChild(this._arrow1);
         addChild(this._arrow2);
         addChild(this._arrow3);
         addChild(this._requestBtn1);
         addChild(this._requestBtn2);
         addChild(this._requestBtn3);
         addChild(this._requestBtn4);
         addChild(this._helpBtn);
         addChild(this._myScorePic);
         addChild(this._myScoreExchangeBtn);
         addChild(this._myScoreTxt);
         addChild(this._ddtmoneyView);
         addChild(this._beadMasterText);
         this.createBtnCartoon();
         this.refreshMoney(null);
      }
      
      private function refreshMoney(param1:PlayerPropertyEvent) : void
      {
         if(this._isBuyOneKey && param1.changedProperties[PlayerInfo.MONEY])
         {
            this._isBuyOneKey = false;
         }
         this._ddtmoneyView.setInfo(PlayerManager.Instance.Self);
         this._myScoreTxt.text = PlayerManager.Instance.Self.beadScore.toString();
         var _loc2_:BuffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.GemMaster];
         this._beadMasterText.visible = _loc2_ && _loc2_.Value > 0;
      }
      
      private function createBtnCartoon() : void
      {
         this._requestBtnCartoon = ClassUtils.CreatInstance("asset.beadSystem.requestBtn.cartoon");
         this._requestBtnCartoon.gotoAndStop(1);
         this._requestBtnCartoon.mouseEnabled = false;
         this._requestBtnCartoon.mouseChildren = false;
         addChild(this._requestBtnCartoon);
      }
      
      private function initEvent() : void
      {
         this._requestBtn1.addEventListener(MouseEvent.CLICK,this.requestBead,false,0,true);
         this._requestBtn2.addEventListener(MouseEvent.CLICK,this.requestBead,false,0,true);
         this._requestBtn3.addEventListener(MouseEvent.CLICK,this.requestBead,false,0,true);
         this._requestBtn4.addEventListener(MouseEvent.CLICK,this.requestBead,false,0,true);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BEAD_RLIGHT_STATE,this.requestBeadHandler,false,0,true);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.refreshMoney,false,0,true);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.openHelpView,false,0,true);
         this._myScoreExchangeBtn.addEventListener(MouseEvent.CLICK,this.openScoreShopFrame,false,0,true);
      }
      
      private function openScoreShopFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BeadScoreShopFrame = ComponentFactory.Instance.creatCustomObject("beadSystem.beadScoreShopFrame");
         _loc2_.show();
      }
      
      private function soundPlay(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function openHelpView(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         param1.stopImmediatePropagation();
         var _loc2_:HelpPrompt = ComponentFactory.Instance.creat("beadSystem.ComposeHelpPrompt");
         var _loc3_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc3_.setView(_loc2_);
         _loc3_.titleText = LanguageMgr.GetTranslation("beadSystem.bead.help.title");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function requestBeadHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         PlayerManager.Instance.Self.beadGetStatus = _loc2_.readInt();
         this.refreshRequestBtn();
      }
      
      private function requestBead(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.doRequestBead(param1);
      }
      
      public function getlightRequestBeadMoney() : int
      {
         var _loc1_:int = PlayerManager.Instance.Self.beadGetStatus;
         var _loc2_:int = -1;
         if(_loc1_ & 8)
         {
            _loc2_ = 3;
         }
         else if(_loc1_ & 4)
         {
            _loc2_ = 2;
         }
         else if(_loc1_ & 2)
         {
            _loc2_ = 1;
         }
         else
         {
            _loc2_ = 0;
         }
         return this._moneyList[_loc2_];
      }
      
      private function doRequestBead(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:int = 1;
         var _loc4_:int = 0;
         switch(_loc2_)
         {
            case this._requestBtn1:
               _loc3_ = 1;
               _loc4_ = this._moneyList[0];
               break;
            case this._requestBtn2:
               _loc3_ = 2;
               _loc4_ = this._moneyList[1];
               break;
            case this._requestBtn3:
               _loc3_ = 3;
               _loc4_ = this._moneyList[2];
               break;
            case this._requestBtn4:
               _loc3_ = 4;
               _loc4_ = this._moneyList[3];
               break;
            default:
               _loc3_ = 1;
               _loc4_ = this._moneyList[0];
         }
         if(PlayerManager.Instance.Self.Gold < _loc4_)
         {
            BeadManager.instance.buyGoldFrame();
            return;
         }
         if(SavePointManager.Instance.isInSavePoint(71))
         {
            if(BeadManager.instance.guildeStepI)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD,0,"trainer.beadClick5","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
            else
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD,90,"trainer.beadClick2","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            }
         }
         SocketManager.Instance.out.sendBeadRequestBead(_loc3_,false,2);
      }
      
      private function refreshRequestBtn() : void
      {
         var _loc1_:int = PlayerManager.Instance.Self.beadGetStatus;
         if(_loc1_ & 1)
         {
            this._requestBtn1.enable = true;
            this._requestBtnCartoon.x = 434;
            this._requestBtnCartoon.y = 268;
         }
         else
         {
            this._requestBtn1.enable = false;
         }
         if(_loc1_ & 2)
         {
            this._requestBtn2.enable = true;
            this._requestBtnCartoon.x = 532;
            this._requestBtnCartoon.y = 268;
         }
         else
         {
            this._requestBtn2.enable = false;
         }
         if(_loc1_ & 4)
         {
            this._requestBtn3.enable = true;
            this._requestBtnCartoon.x = 639;
            this._requestBtnCartoon.y = 271;
         }
         else
         {
            this._requestBtn3.enable = false;
         }
         if(_loc1_ & 8)
         {
            this._requestBtn4.enable = true;
            this._requestBtnCartoon.x = 740;
            this._requestBtnCartoon.y = 270;
         }
         else
         {
            this._requestBtn4.enable = false;
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function removeEvent() : void
      {
         this._requestBtn1.removeEventListener(MouseEvent.CLICK,this.requestBead);
         this._requestBtn2.removeEventListener(MouseEvent.CLICK,this.requestBead);
         this._requestBtn3.removeEventListener(MouseEvent.CLICK,this.requestBead);
         this._requestBtn4.removeEventListener(MouseEvent.CLICK,this.requestBead);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BEAD_RLIGHT_STATE,this.requestBeadHandler);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.refreshMoney);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.openHelpView);
         this._myScoreExchangeBtn.removeEventListener(MouseEvent.CLICK,this.openScoreShopFrame);
      }
      
      private function disposeCartoon() : void
      {
         if(this._requestBtnCartoon)
         {
            this._requestBtnCartoon.gotoAndStop(this._requestBtnCartoon.totalFrames);
            ObjectUtils.disposeObject(this._requestBtnCartoon);
            this._requestBtnCartoon = null;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeCartoon();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._arrow1)
         {
            ObjectUtils.disposeObject(this._arrow1);
         }
         this._arrow1 = null;
         if(this._arrow2)
         {
            ObjectUtils.disposeObject(this._arrow2);
         }
         this._arrow2 = null;
         if(this._arrow3)
         {
            ObjectUtils.disposeObject(this._arrow3);
         }
         this._arrow3 = null;
         if(this._myScorePic)
         {
            ObjectUtils.disposeObject(this._myScorePic);
         }
         this._myScorePic = null;
         if(this._requestBtn1)
         {
            ObjectUtils.disposeObject(this._requestBtn1);
         }
         this._requestBtn1 = null;
         if(this._requestBtn2)
         {
            ObjectUtils.disposeObject(this._requestBtn2);
         }
         this._requestBtn2 = null;
         if(this._requestBtn3)
         {
            ObjectUtils.disposeObject(this._requestBtn3);
         }
         this._requestBtn3 = null;
         if(this._requestBtn4)
         {
            ObjectUtils.disposeObject(this._requestBtn4);
         }
         this._requestBtn4 = null;
         if(this._helpBtn)
         {
            ObjectUtils.disposeObject(this._helpBtn);
         }
         this._helpBtn = null;
         if(this._myScoreExchangeBtn)
         {
            ObjectUtils.disposeObject(this._myScoreExchangeBtn);
         }
         this._myScoreExchangeBtn = null;
         if(this._myScoreTxt)
         {
            ObjectUtils.disposeObject(this._myScoreTxt);
         }
         this._myScoreTxt = null;
         ObjectUtils.disposeObject(this._beadMasterText);
         this._beadMasterText = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
