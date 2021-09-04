package SingleDungeon.expedition.view
{
   import SingleDungeon.SingleDungeonManager;
   import SingleDungeon.expedition.ExpeditionController;
   import SingleDungeon.expedition.ExpeditionInfo;
   import SingleDungeon.expedition.IExpeditionFrame;
   import SingleDungeon.expedition.msg.FightMsgInfo;
   import SingleDungeon.expedition.msg.FightMsgItem;
   import SingleDungeon.model.MapSceneModel;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ExpeditionFrame extends Frame implements IExpeditionFrame
   {
      
      private static var NORMAL:int = -1;
      
      private static var START:int = 1;
      
      private static var ACCELERATE:int = 2;
      
      private static var STOP:int = 3;
      
      private static var UPDATE:int = 4;
      
      private static var HARD_MODE_START:int = 5;
       
      
      private var _headBg:Scale9CornerImage;
      
      private var _downBg:MutipleImage;
      
      private var _headExplain:Bitmap;
      
      private var _headExplainText:FilterFrameText;
      
      private var _mapNameText:FilterFrameText;
      
      private var _mapNameBg:Bitmap;
      
      private var _scrollHead:ScrollPanel;
      
      private var _scrollDown:ScrollPanel;
      
      private var _fightMsgVbox:VBox;
      
      private var _infoBefore:ExpeditionInfoBefore;
      
      private var _infoIng:ExpeditionInfoIng;
      
      private var _vipBg:Bitmap;
      
      private var _vipIcon:Bitmap;
      
      private var _vipText:FilterFrameText;
      
      private var _startBtn:TextButton;
      
      private var _accelerateBtn:TextButton;
      
      private var _stopBtn:TextButton;
      
      private var _start:Boolean = false;
      
      private var _expeditionInfo:ExpeditionInfo;
      
      private var _rewardPanelBg:Bitmap;
      
      private var _rewardPanelTitle:Bitmap;
      
      private var _expeditionVLine:Bitmap;
      
      private var _accelerateFrame:BaseAlerFrame;
      
      public function ExpeditionFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function show() : void
      {
         if(ExpeditionController.instance.model.lastScenceID)
         {
            this._expeditionInfo = ExpeditionController.instance.model.expeditionInfoDic[PlayerManager.Instance.Self.expeditionCurrent.SceneID];
         }
         else
         {
            this._expeditionInfo = ExpeditionController.instance.model.expeditionInfoDic[ExpeditionController.instance.model.currentMapId];
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.showName();
         this.updateView();
      }
      
      public function updateFatigue() : void
      {
         this._infoBefore.update();
      }
      
      private function showName() : void
      {
         var _loc1_:String = null;
         var _loc2_:Vector.<MapSceneModel> = null;
         var _loc3_:MapSceneModel = null;
         if(ExpeditionController.instance.model.getscenceNameByID(this._expeditionInfo.SceneID))
         {
            _loc1_ = ExpeditionController.instance.model.getscenceNameByID(this._expeditionInfo.SceneID);
         }
         else
         {
            _loc2_ = SingleDungeonManager.Instance.mapSceneList;
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.ID == this._expeditionInfo.SceneID)
               {
                  _loc1_ = _loc3_.Name;
               }
            }
            ExpeditionController.instance.model.addscenceNameDic(this._expeditionInfo.SceneID,_loc1_);
         }
         this._mapNameText.text = _loc1_;
      }
      
      private function updateView(param1:int = -1) : void
      {
         if(param1 == NORMAL)
         {
            this._headExplainText.htmlText = LanguageMgr.GetTranslation("singledungeon.expedition.frame.explainText");
            this._scrollHead.invalidateViewport();
            this._scrollDown.invalidateViewport();
            this._infoBefore.setinfo(this._expeditionInfo);
            if(PlayerManager.Instance.checkExpedition())
            {
               this._infoBefore.visible = false;
               this._infoIng.visible = true;
               param1 = START;
               this._infoIng.update();
               this.megChange();
            }
            else
            {
               this.megChange();
            }
         }
         else
         {
            switch(param1)
            {
               case START:
                  this.startExpedtion();
                  break;
               case ACCELERATE:
                  this.accelerateExpedition();
                  break;
               case STOP:
                  this.stopExpedtion();
                  break;
               case UPDATE:
                  this.updateExpedition();
            }
         }
         this.updateBtn(param1);
      }
      
      private function startExpedtion() : void
      {
         ExpeditionController.instance.model.clearGetItemsDic();
         this.removeVboxChild();
         this.showStartMes();
         this._infoBefore.visible = false;
         this._infoIng.visible = true;
         this._infoIng.update();
      }
      
      private function stopExpedtion() : void
      {
         this._infoBefore.visible = true;
         this._infoIng.visible = false;
         this._infoBefore.update();
         this.megChange();
      }
      
      private function accelerateExpedition() : void
      {
      }
      
      private function cancleExpedition() : void
      {
         this._infoBefore.visible = true;
         this._infoIng.visible = false;
         this._infoBefore.update();
         this.megChange();
      }
      
      private function updateExpedition() : void
      {
         this._infoIng.update();
         this.megChange();
      }
      
      private function updateBtn(param1:int) : void
      {
         this._startBtn.enable = param1 == NORMAL || param1 == STOP ? Boolean(true) : Boolean(false);
         this._accelerateBtn.enable = (param1 == START || param1 == UPDATE) && this._expeditionInfo.IsOnExpedition ? Boolean(true) : Boolean(false);
         this._stopBtn.enable = param1 == START || param1 == UPDATE ? Boolean(true) : Boolean(false);
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("singledungeon.expedition.frame.title");
         this.headView();
         this.downView();
         this.buttonInitView();
      }
      
      private function headView() : void
      {
         this._headBg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.headViewBg");
         addToContent(this._headBg);
         this._headExplainText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.headExplain.text");
         this._infoBefore = ComponentFactory.Instance.creatCustomObject("SingleDungeon.expedition.expeditionInfoBefore");
         addToContent(this._infoBefore);
         this._expeditionVLine = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.expedition.line");
         addToContent(this._expeditionVLine);
         this._infoIng = ComponentFactory.Instance.creatCustomObject("SingleDungeon.expedition.expeditionInfoIng");
         this._infoIng.visible = false;
         addToContent(this._infoIng);
         this._rewardPanelBg = ComponentFactory.Instance.creatBitmap("asset.expedition.rewardPanelBg");
         addToContent(this._rewardPanelBg);
         this._rewardPanelTitle = ComponentFactory.Instance.creatBitmap("asset.expedition.rewardPanelTitle");
         addToContent(this._rewardPanelTitle);
         this._fightMsgVbox = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.downFightMsg.vbox");
         this._scrollDown = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ScrollPanel.down");
         addToContent(this._scrollDown);
         this._scrollDown.setView(this._fightMsgVbox);
      }
      
      private function downView() : void
      {
         this._downBg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.downViewBg");
         addToContent(this._downBg);
         this._mapNameBg = ComponentFactory.Instance.creatBitmap("asset.core.newFrame.titleBg");
         PositionUtils.setPos(this._mapNameBg,"asset.experition.titleBg");
         addToContent(this._mapNameBg);
         this._mapNameText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.mapName.text");
         addToContent(this._mapNameText);
         this._headExplain = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.expeditionHelpTitle");
         addToContent(this._headExplain);
         this._scrollHead = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.ScrollPanel.head");
         addToContent(this._scrollHead);
         this._scrollHead.setView(this._headExplainText);
      }
      
      private function vipView() : void
      {
         this._vipBg = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.expedition.vipBg");
         addToContent(this._vipBg);
         this._vipIcon = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.SmallVipIcon5");
         addToContent(this._vipIcon);
         this._vipText = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.vip.text");
         this._vipText.text = LanguageMgr.GetTranslation("singledungeon.expedition.vip");
         addToContent(this._vipText);
      }
      
      private function buttonInitView() : void
      {
         this._startBtn = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.start");
         this._startBtn.text = LanguageMgr.GetTranslation("singledungeon.expedition.frame.button.start");
         addToContent(this._startBtn);
         this._accelerateBtn = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.accelerat");
         this._accelerateBtn.text = LanguageMgr.GetTranslation("singledungeon.expedition.frame.button.accelerate");
         addToContent(this._accelerateBtn);
         this._stopBtn = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.stop");
         this._stopBtn.text = LanguageMgr.GetTranslation("singledungeon.expedition.frame.button.stop");
         addToContent(this._stopBtn);
      }
      
      private function removeVboxChild() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._fightMsgVbox.numChildren)
         {
            _loc1_++;
         }
         this._fightMsgVbox.disposeAllChildren();
      }
      
      private function addVboxChild(param1:FightMsgInfo) : void
      {
         if(param1.templateID == -100 && param1.count == 0)
         {
            return;
         }
         var _loc2_:FightMsgItem = new FightMsgItem();
         _loc2_.info = param1;
         this._fightMsgVbox.addChild(_loc2_);
         this._scrollDown.invalidateViewport(true);
      }
      
      private function showStartMes() : void
      {
         var _loc1_:FightMsgInfo = null;
         if(ExpeditionController.instance.showStart)
         {
            _loc1_ = new FightMsgInfo();
            _loc1_.templateID = -1;
            this.addVboxChild(_loc1_);
         }
      }
      
      private function showStopMes() : void
      {
         var _loc1_:FightMsgInfo = null;
         if(ExpeditionController.instance.showStop)
         {
            _loc1_ = new FightMsgInfo();
            _loc1_.templateID = -2;
            this.addVboxChild(_loc1_);
            ExpeditionController.instance.showStart = false;
            ExpeditionController.instance.showStop = false;
            ExpeditionController.instance.model.clearGetItemsDic();
            this._infoBefore.update();
         }
      }
      
      private function megChange() : void
      {
         var _loc2_:Vector.<FightMsgInfo> = null;
         var _loc3_:FightMsgInfo = null;
         var _loc4_:FightMsgInfo = null;
         this.removeVboxChild();
         this.showStartMes();
         var _loc1_:int = 0;
         for each(_loc2_ in ExpeditionController.instance.model.getItemsDic)
         {
            _loc1_++;
            _loc3_ = new FightMsgInfo();
            _loc3_.templateID = 1;
            _loc3_.times = _loc1_;
            this.addVboxChild(_loc3_);
            for each(_loc4_ in _loc2_)
            {
               this.addVboxChild(_loc4_);
            }
         }
         this.showStopMes();
         this._scrollDown.invalidateViewport(true);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._startBtn.addEventListener(MouseEvent.CLICK,this.__start);
         this._accelerateBtn.addEventListener(MouseEvent.CLICK,this.__accelerate);
         this._stopBtn.addEventListener(MouseEvent.CLICK,this.__stop);
         ExpeditionController.instance.addEventListener(ExpeditionEvents.UPDATE,this.__updateBySocket);
      }
      
      private function __updateBySocket(param1:ExpeditionEvents) : void
      {
         this._expeditionInfo.IsOnExpedition = PlayerManager.Instance.Self.expeditionCurrent.IsOnExpedition;
         var _loc2_:String = param1.action;
         var _loc3_:int = 0;
         switch(_loc2_)
         {
            case "start":
               _loc3_ = START;
               ExpeditionController.instance.showStart = true;
               ExpeditionController.instance.showStop = false;
               break;
            case "accelerate":
               _loc3_ = ACCELERATE;
               break;
            case "stop":
               _loc3_ = STOP;
               ExpeditionController.instance.showStart = true;
               ExpeditionController.instance.showStop = true;
               break;
            case "update":
               _loc3_ = UPDATE;
               if(PlayerManager.Instance.Self.expeditionCurrent.IsOnExpedition)
               {
                  ExpeditionController.instance.showStart = true;
               }
         }
         this.updateView(_loc3_);
         this._start = false;
      }
      
      private function __stop(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._infoBefore.visible = true;
         this._infoIng.visible = false;
         var _loc2_:Array = new Array();
         ExpeditionController.instance.sendSocket(STOP);
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               if(PlayerManager.Instance.checkExpedition() || this._start)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.doing"));
               }
               else
               {
                  ExpeditionController.instance.hide();
                  ExpeditionController.instance.model.lastScenceID = 0;
               }
         }
      }
      
      private function __start(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(!this._infoBefore.checkFatigue())
         {
            if(this._infoBefore.times == -1)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.notimes"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("singledungeon.expedition.fatigueNotEnought"));
            }
            return;
         }
         this._start = true;
         var _loc2_:Array = new Array();
         _loc2_["sceneID"] = this._expeditionInfo.SceneID;
         _loc2_["count"] = this._infoBefore.times;
         ExpeditionController.instance.sendSocket(START,_loc2_);
      }
      
      private function __accelerate(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc2_.data = LanguageMgr.GetTranslation("singledungeon.expedition.frame.accelerateAlert",this._expeditionInfo.AccelerateMoney * PlayerManager.Instance.Self.expeditionNumLast);
         _loc2_.enableHtml = true;
         _loc2_.moveEnable = false;
         this._accelerateFrame = AlertManager.Instance.alert("SimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
         this._accelerateFrame.addEventListener(FrameEvent.RESPONSE,this.__accelerateFrameResponse);
      }
      
      private function __accelerateFrameResponse(param1:FrameEvent) : void
      {
         var _loc2_:Array = null;
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < this._expeditionInfo.AccelerateMoney * PlayerManager.Instance.Self.expeditionNumLast)
            {
               LeavePageManager.showFillFrame();
            }
            else
            {
               this._infoBefore.visible = true;
               this._infoIng.visible = false;
               _loc2_ = new Array();
               _loc2_["sceneID"] = this._expeditionInfo.SceneID;
               ExpeditionController.instance.sendSocket(ACCELERATE,_loc2_);
            }
         }
         this._accelerateFrame.removeEventListener(FrameEvent.RESPONSE,this.__accelerateFrameResponse);
         this._accelerateFrame.dispose();
      }
      
      public function updateRemainTxt(param1:String) : void
      {
         this._infoIng.updateRemainTxt(param1);
      }
      
      private function removeView() : void
      {
         if(this._downBg)
         {
            ObjectUtils.disposeObject(this._downBg);
            this._downBg = null;
         }
         if(this._headBg)
         {
            ObjectUtils.disposeObject(this._headBg);
            this._headBg = null;
         }
         if(this._mapNameBg)
         {
            ObjectUtils.disposeObject(this._mapNameBg);
            this._mapNameBg = null;
         }
         if(this._scrollHead)
         {
            ObjectUtils.disposeObject(this._scrollHead);
            this._scrollHead = null;
         }
         if(this._scrollDown)
         {
            ObjectUtils.disposeObject(this._scrollDown);
            this._scrollDown = null;
         }
         if(this._mapNameText)
         {
            ObjectUtils.disposeObject(this._mapNameText);
            this._mapNameText = null;
         }
         if(this._infoIng)
         {
            ObjectUtils.disposeObject(this._infoIng);
            this._infoIng = null;
         }
         if(this._infoBefore)
         {
            ObjectUtils.disposeObject(this._infoBefore);
            this._infoBefore = null;
         }
         if(this._vipBg)
         {
            ObjectUtils.disposeObject(this._vipBg);
            this._vipBg = null;
         }
         if(this._vipIcon)
         {
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
         }
         if(this._vipText)
         {
            ObjectUtils.disposeObject(this._vipText);
            this._vipText = null;
         }
         if(this._startBtn)
         {
            ObjectUtils.disposeObject(this._startBtn);
            this._startBtn = null;
         }
         if(this._accelerateBtn)
         {
            ObjectUtils.disposeObject(this._accelerateBtn);
            this._accelerateBtn = null;
         }
         if(this._stopBtn)
         {
            ObjectUtils.disposeObject(this._stopBtn);
            this._stopBtn = null;
         }
         ObjectUtils.disposeObject(this._rewardPanelBg);
         this._rewardPanelBg = null;
         ObjectUtils.disposeObject(this._rewardPanelTitle);
         this._rewardPanelTitle = null;
         ObjectUtils.disposeObject(this._expeditionVLine);
         this._expeditionVLine = null;
         ObjectUtils.disposeObject(this._headExplain);
         this._headExplain = null;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._startBtn.removeEventListener(MouseEvent.CLICK,this.__start);
         this._accelerateBtn.removeEventListener(MouseEvent.CLICK,this.__accelerate);
         this._stopBtn.removeEventListener(MouseEvent.CLICK,this.__stop);
         ExpeditionController.instance.removeEventListener(ExpeditionEvents.UPDATE,this.__updateBySocket);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this.removeView();
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
