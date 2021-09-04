package ddt.view
{
   import bagAndInfo.BagAndInfoManager;
   import calendar.CalendarManager;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.TaskEvent;
   import ddt.manager.ChurchManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PetBagManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskDirectorManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import email.manager.MailManager;
   import email.view.EmailEvent;
   import exitPrompt.ExitPromptManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import gotopage.view.GotoPageController;
   import im.IMController;
   import quest.QuestBubbleManager;
   import setting.controll.SettingController;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class MainToolBar extends Sprite
   {
      
      public static const ENTER_HALL:int = 0;
      
      public static const LEAVE_HALL:int = 1;
      
      private static var _instance:MainToolBar;
       
      
      private var _toolBarBg:Bitmap;
      
      private var _goSupplyBtn:SimpleButton;
      
      private var _goShopBtn:SimpleButton;
      
      private var _goBagBtn:SimpleButton;
      
      private var _goEmailBtn:SimpleButton;
      
      private var _goTaskBtn:SimpleButton;
      
      private var _goFriendListBtn:SimpleButton;
      
      private var _goSignBtn:SimpleButton;
      
      private var _goChannelBtn:SimpleButton;
      
      private var _goReturnBtn:SimpleButton;
      
      private var _goExitBtn:SimpleButton;
      
      private var _gameSetBtn:BaseButton;
      
      private var _goPetBtn:SimpleButton;
      
      private var _callBackFun:Function;
      
      private var _unReadEmail:Boolean;
      
      private var _unReadTask:Boolean;
      
      private var _enabled:Boolean;
      
      private var _unReadMovement:Boolean;
      
      private var _taskEffectEnable:Boolean;
      
      private var _signEffectEnable:Boolean = true;
      
      private var _boxContainer:HBox;
      
      private var allBtns:Array;
      
      private var _isEvent:Boolean;
      
      private var _hasClickTaskBtn:Boolean;
      
      private var _emailShineEffect:IEffect;
      
      private var _taskShineEffect:IEffect;
      
      private var _friendShineEffec:IEffect;
      
      private var _bagAppearMc:MovieClip;
      
      private var _taskAppearMc:MovieClip;
      
      private var _shopAppearMc:MovieClip;
      
      private var _petAppearMc:MovieClip;
      
      private var _friendAppearMc:MovieClip;
      
      private var _emailAppearMc:MovieClip;
      
      private var bagAppearPos:Point;
      
      private var taskAppearPos:Point;
      
      private var shopAppearPos:Point;
      
      private var petAppearPos:Point;
      
      private var friendAppearPos:Point;
      
      private var emailAppearPos:Point;
      
      private var _mask:Sprite;
      
      private var _talkTimer:Timer;
      
      public function MainToolBar()
      {
         this._talkTimer = new Timer(1000);
         super();
         this.initView();
         this.initEvent();
      }
      
      public static function get Instance() : MainToolBar
      {
         if(_instance == null)
         {
            _instance = new MainToolBar();
         }
         return _instance;
      }
      
      private function initView() : void
      {
         this._toolBarBg = ComponentFactory.Instance.creatBitmap("asset.toolbar.toolBarBg");
         this._goSupplyBtn = ComponentFactory.Instance.creat("toolbar.gochargebtn");
         this._goShopBtn = ComponentFactory.Instance.creat("toolbar.goshopbtn");
         this._goBagBtn = ComponentFactory.Instance.creatCustomObject("toolbar.gobagbtn");
         this._goEmailBtn = ComponentFactory.Instance.creatCustomObject("toolbar.goemailbtn");
         this._goTaskBtn = ComponentFactory.Instance.creatCustomObject("toolbar.gotaskbtn");
         this._goFriendListBtn = ComponentFactory.Instance.creatCustomObject("toolbar.goimbtn");
         this._goChannelBtn = ComponentFactory.Instance.creatCustomObject("toolbar.turntobtn");
         this._goReturnBtn = ComponentFactory.Instance.creatCustomObject("toolbar.gobackbtn");
         this._goExitBtn = ComponentFactory.Instance.creatCustomObject("toolbar.goexitbtn");
         this._gameSetBtn = ComponentFactory.Instance.creat("toolbar.setbtn");
         this._goPetBtn = ComponentFactory.Instance.creatCustomObject("toolbar.gopetbtn");
         this.allBtns = [];
         this.allBtns.push(this._goShopBtn);
         this.allBtns.push(this._goBagBtn);
         this.allBtns.push(this._goEmailBtn);
         this.allBtns.push(this._goTaskBtn);
         this.allBtns.push(this._goFriendListBtn);
         this.allBtns.push(this._goChannelBtn);
         this.allBtns.push(this._goReturnBtn);
         this.allBtns.push(this._goSupplyBtn);
         this.allBtns.push(this._gameSetBtn);
         this.allBtns.push(this._goPetBtn);
         this._goEmailBtn.enabled = false;
         this._goTaskBtn.enabled = false;
         addChild(this._toolBarBg);
         addChild(this._goReturnBtn);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("toolbar.bagShineIconPos");
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("toolbar.ShineAssetPos");
         this._emailShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goEmailBtn,"asset.toolbar.EmailBtnGlow",_loc2_);
         this._friendShineEffec = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goFriendListBtn,"asset.toolbar.friendBtnGlow",_loc2_);
         this.bagAppearPos = ComponentFactory.Instance.creatCustomObject("toolbar.bagBtnAppearPos");
         this.taskAppearPos = ComponentFactory.Instance.creatCustomObject("toolbar.taskBtnAppearPos");
         this.shopAppearPos = ComponentFactory.Instance.creatCustomObject("toolbar.shopBtnAppearPos");
         this.petAppearPos = ComponentFactory.Instance.creatCustomObject("toolbar.petBtnAppearPos");
         this.friendAppearPos = ComponentFactory.Instance.creatCustomObject("toolbar.friendBtnAppearPos");
         this.emailAppearPos = ComponentFactory.Instance.creatCustomObject("toolbar.emailBtnAppearPos");
         if(MailManager.Instance.Model.hasUnReadEmail())
         {
            this.showEmailShineEffect(true);
            this._unReadEmail = true;
         }
         else
         {
            this.showEmailShineEffect(false);
            this._unReadEmail = false;
         }
         this._taskShineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goTaskBtn,"asset.toolbar.TaskBtnGlow",_loc2_);
      }
      
      public function set state(param1:String) : void
      {
         ObjectUtils.disposeObject(this._mask);
         this._mask = null;
         this.mask = null;
         if(param1 == StateType.ARENA)
         {
            this._mask = new Sprite();
            this._mask.mouseEnabled = false;
            this._mask.graphics.beginFill(0);
            this._mask.graphics.drawRect(this._goReturnBtn.x,this._goReturnBtn.y - 20,this.width - 60,this.height + 20);
            this._mask.graphics.endFill();
            addChild(this._mask);
            this.mask = this._mask;
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         this.update();
      }
      
      public function enableAll() : void
      {
         this.enabled = true;
         this._goExitBtn.enabled = true;
         this.setReturnEnable(true);
      }
      
      public function disableAll() : void
      {
         this.enabled = false;
         this._goExitBtn.enabled = false;
      }
      
      public function canOpenBag() : Boolean
      {
         return this.parent && this._goBagBtn.alpha == 1 && this._goBagBtn.enabled && this._goBagBtn.mouseEnabled;
      }
      
      private function initEvent() : void
      {
         this._isEvent = true;
         this._goSupplyBtn.addEventListener(MouseEvent.CLICK,this.__onSupplyClick);
         this._goShopBtn.addEventListener(MouseEvent.CLICK,this.__onShopClick);
         this._goBagBtn.addEventListener(MouseEvent.CLICK,this.__onBagClick);
         this._goEmailBtn.addEventListener(MouseEvent.CLICK,this.__onEmailClick);
         this._goTaskBtn.addEventListener(MouseEvent.MOUSE_OVER,this._overTaskBtn);
         this._goTaskBtn.addEventListener(MouseEvent.MOUSE_OUT,this._outTaskBtn);
         this._goTaskBtn.addEventListener(MouseEvent.CLICK,this.__onTaskClick);
         this._goFriendListBtn.addEventListener(MouseEvent.CLICK,this.__onImClick);
         this._goFriendListBtn.addEventListener(MouseEvent.MOUSE_OVER,this.__friendOverHandler);
         this._goFriendListBtn.addEventListener(MouseEvent.MOUSE_OUT,this.__friendOutHandler);
         this._goChannelBtn.addEventListener(MouseEvent.CLICK,this.__onChannelClick);
         this._goReturnBtn.addEventListener(MouseEvent.CLICK,this.__onReturnClick);
         this._goExitBtn.addEventListener(MouseEvent.CLICK,this.__onExitClick);
         this._gameSetBtn.addEventListener(MouseEvent.CLICK,this.__gameSet);
         this._goPetBtn.addEventListener(MouseEvent.CLICK,this.__onPetClick);
         MailManager.Instance.Model.addEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
         IMController.Instance.addEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewHandler);
         IMController.Instance.addEventListener(IMController.NO_MESSAGE,this.__noMessageHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         TaskManager.instance.addEventListener(TaskEvent.SHOW_ARROW,this.__showArrow);
      }
      
      protected function __onPetClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         PetBagManager.instance().openPetFrame();
      }
      
      protected function __addToStageHandler(param1:Event) : void
      {
         if(IMController.Instance.hasUnreadMessage() && !IMController.Instance.cancelflashState)
         {
            this.showFriendShineEffec(true);
         }
         else
         {
            this.showFriendShineEffec(false);
         }
      }
      
      protected function __noMessageHandler(param1:Event) : void
      {
         this.showFriendShineEffec(false);
      }
      
      protected function __hasNewHandler(param1:Event) : void
      {
         if(!this._talkTimer.running)
         {
            SoundManager.instance.play("200");
            this._talkTimer.start();
            this._talkTimer.addEventListener(TimerEvent.TIMER,this.__stopTalkTime);
         }
         this.showFriendShineEffec(true);
      }
      
      private function __stopTalkTime(param1:TimerEvent) : void
      {
         this._talkTimer.stop();
         this._talkTimer.removeEventListener(TimerEvent.TIMER,this.__stopTalkTime);
      }
      
      protected function __friendOverHandler(param1:MouseEvent) : void
      {
         IMController.Instance.showMessageBox(this._goFriendListBtn);
      }
      
      protected function __friendOutHandler(param1:MouseEvent) : void
      {
         IMController.Instance.hideMessageBox();
      }
      
      public function btnOpen() : void
      {
         addChild(this._goSupplyBtn);
         addChild(this._goChannelBtn);
         addChild(this._goEmailBtn);
         this._goEmailBtn.enabled = true;
         if(SavePointManager.Instance.savePoints[62])
         {
            if(!this._goFriendListBtn.parent)
            {
               addChild(this._goFriendListBtn);
            }
         }
         if(SavePointManager.Instance.savePoints[1])
         {
            if(!this._goBagBtn.parent)
            {
               addChild(this._goBagBtn);
            }
            if(!this._goTaskBtn.parent)
            {
               addChild(this._goTaskBtn);
               this._goTaskBtn.enabled = true;
            }
         }
         if(SavePointManager.Instance.savePoints[14])
         {
            if(!this._goShopBtn.parent)
            {
               addChild(this._goShopBtn);
            }
         }
         if(SavePointManager.Instance.savePoints[54])
         {
            if(!this._goPetBtn.parent)
            {
               addChild(this._goPetBtn);
            }
         }
         if(!SavePointManager.Instance.savePoints[1])
         {
            this._goBagBtn.alpha = 0;
            this._goTaskBtn.alpha = 0;
            this._goEmailBtn.alpha = 0;
         }
         else
         {
            this._goBagBtn.alpha = 1;
         }
         if(!SavePointManager.Instance.savePoints[2])
         {
            SavePointManager.Instance.setSavePoint(2);
            this.tipTask();
         }
      }
      
      public function set backFunction(param1:Function) : void
      {
         this._callBackFun = param1;
      }
      
      public function get backFunction() : Function
      {
         return this._callBackFun;
      }
      
      private function removeEvent() : void
      {
         this._isEvent = false;
         this._goSupplyBtn.removeEventListener(MouseEvent.CLICK,this.__onSupplyClick);
         this._goShopBtn.removeEventListener(MouseEvent.CLICK,this.__onShopClick);
         this._goBagBtn.removeEventListener(MouseEvent.CLICK,this.__onBagClick);
         this._goEmailBtn.removeEventListener(MouseEvent.CLICK,this.__onEmailClick);
         this._goTaskBtn.removeEventListener(MouseEvent.MOUSE_OVER,this._overTaskBtn);
         this._goTaskBtn.removeEventListener(MouseEvent.MOUSE_OUT,this._outTaskBtn);
         this._goTaskBtn.removeEventListener(MouseEvent.CLICK,this.__onTaskClick);
         this._goFriendListBtn.removeEventListener(MouseEvent.CLICK,this.__onImClick);
         this._goFriendListBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.__friendOverHandler);
         this._goFriendListBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.__friendOutHandler);
         this._goChannelBtn.removeEventListener(MouseEvent.CLICK,this.__onChannelClick);
         this._goReturnBtn.removeEventListener(MouseEvent.CLICK,this.__onReturnClick);
         this._goExitBtn.removeEventListener(MouseEvent.CLICK,this.__onExitClick);
         this._gameSetBtn.removeEventListener(MouseEvent.CLICK,this.__gameSet);
         this._goPetBtn.removeEventListener(MouseEvent.CLICK,this.__onPetClick);
         MailManager.Instance.Model.removeEventListener(EmailEvent.INIT_EMAIL,this.__updateEmail);
         IMController.Instance.removeEventListener(IMController.HAS_NEW_MESSAGE,this.__hasNewHandler);
         IMController.Instance.removeEventListener(IMController.NO_MESSAGE,this.__noMessageHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         TaskManager.instance.removeEventListener(TaskEvent.SHOW_ARROW,this.__showArrow);
      }
      
      public function show() : void
      {
         if(!this._isEvent)
         {
            this.initEvent();
         }
         this.enableAll();
         if(StateManager.currentStateType == StateType.SINGLEDUNGEON)
         {
            this._toolBarBg.visible = false;
         }
         else
         {
            this._toolBarBg.visible = true;
         }
         if(IMController.Instance.hasUnreadMessage() && !IMController.Instance.cancelflashState)
         {
            this.showFriendShineEffec(true);
         }
         else
         {
            this.showFriendShineEffec(false);
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_UI_LAYER,false,0,false);
      }
      
      public function showTop() : void
      {
         if(!this._isEvent)
         {
            this.initEvent();
         }
         this.enableAll();
         this._toolBarBg.visible = true;
         if(IMController.Instance.hasUnreadMessage() && !IMController.Instance.cancelflashState)
         {
            this.showFriendShineEffec(true);
         }
         else
         {
            this.showFriendShineEffec(false);
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,false,0,false);
      }
      
      public function hide() : void
      {
         this.dispose();
      }
      
      public function showIconAppear(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               addChild(this._goBagBtn);
               this._bagAppearMc = ComponentFactory.Instance.creatCustomObject("toolbar.bagbtn.appear");
               addChild(this._bagAppearMc);
               this._goBagBtn.alpha = 0;
               break;
            case 1:
               addChild(this._goTaskBtn);
               this._taskAppearMc = ComponentFactory.Instance.creatCustomObject("toolbar.taskbtn.appear");
               addChild(this._taskAppearMc);
               this._goTaskBtn.alpha = 0;
               SavePointManager.Instance.setSavePoint(1);
               break;
            case 2:
               addChild(this._goShopBtn);
               this._shopAppearMc = ComponentFactory.Instance.creatCustomObject("toolbar.shopbtn.appear");
               addChild(this._shopAppearMc);
               this._goShopBtn.alpha = 0;
               break;
            case 3:
               addChild(this._goEmailBtn);
               this._emailAppearMc = ComponentFactory.Instance.creatCustomObject("toolbar.emailbtn.appear");
               addChild(this._emailAppearMc);
               this._goEmailBtn.alpha = 0;
               break;
            case 4:
               addChild(this._goFriendListBtn);
               this._friendAppearMc = ComponentFactory.Instance.creatCustomObject("toolbar.friendbtn.appear");
               addChild(this._friendAppearMc);
               this._goFriendListBtn.alpha = 0;
               SavePointManager.Instance.setSavePoint(62);
               break;
            case 5:
               addChild(this._goPetBtn);
               this._petAppearMc = ComponentFactory.Instance.creatCustomObject("toolbar.petbtn.appear");
               addChild(this._petAppearMc);
               this._goPetBtn.alpha = 0;
               SavePointManager.Instance.setSavePoint(54);
         }
         setTimeout(this.btnAppearEnd,4000,param1);
      }
      
      public function setRoomStartState() : void
      {
         this._goReturnBtn.enabled = this._goShopBtn.enabled = this._goSupplyBtn.enabled = this._goPetBtn.enabled = false;
         this._goReturnBtn.mouseEnabled = this._goShopBtn.mouseEnabled = this._goSupplyBtn.mouseEnabled = this._goPetBtn.mouseEnabled = false;
         this.setFilter(false);
         this.setMailEnable(false);
         this.setChannelEnable(false);
         this.setBagEnable(false);
         this.showEmailShineEffect(false);
      }
      
      public function setRoomStartState2(param1:Boolean) : void
      {
         this._goReturnBtn.enabled = this._goShopBtn.enabled = this._goSupplyBtn.enabled = this._goPetBtn.enabled = param1;
         this._goReturnBtn.mouseEnabled = this._goShopBtn.mouseEnabled = this._goSupplyBtn.mouseEnabled = this._goPetBtn.mouseEnabled = param1;
         this.setFilter(param1);
         this.setMailEnable(param1);
         this.setChannelEnable(param1);
         this.setBagEnable(param1);
         this.updateEmail();
      }
      
      public function setReturnEnable(param1:Boolean) : void
      {
         this._goChannelBtn.enabled = param1;
         this._goChannelBtn.mouseEnabled = param1;
         this._goReturnBtn.enabled = param1;
         this._goReturnBtn.mouseEnabled = param1;
         if(param1)
         {
            this._goChannelBtn.filters = null;
            this._goReturnBtn.filters = null;
         }
         else
         {
            this._goChannelBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._goReturnBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      private function setFilter(param1:Boolean) : void
      {
         if(param1)
         {
            this._goReturnBtn.filters = null;
            this._goShopBtn.filters = null;
            this._goSupplyBtn.filters = null;
            this._goPetBtn.filters = null;
         }
         else
         {
            this._goReturnBtn.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
            this._goShopBtn.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
            this._goSupplyBtn.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
            this._goPetBtn.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
         }
      }
      
      public function updateReturnBtn(param1:int) : void
      {
         switch(param1)
         {
            case ENTER_HALL:
               addChild(this._goExitBtn);
               if(this._goReturnBtn.parent)
               {
                  ObjectUtils.disposeObject(this._goReturnBtn);
                  this._goReturnBtn = ComponentFactory.Instance.creatCustomObject("toolbar.gobackbtn");
               }
               break;
            case LEAVE_HALL:
               addChild(this._goReturnBtn);
               if(this._goExitBtn.parent)
               {
                  this._goExitBtn.parent.removeChild(this._goExitBtn);
               }
         }
      }
      
      public function set ExitBtnVisible(param1:Boolean) : void
      {
         this._goExitBtn.visible = param1;
      }
      
      private function btnAppearEnd(param1:uint) : void
      {
         switch(param1)
         {
            case 0:
               if(this._bagAppearMc)
               {
                  ObjectUtils.disposeObject(this._bagAppearMc);
                  this._bagAppearMc = null;
               }
               this._goBagBtn.alpha = 1;
               break;
            case 1:
               if(this._taskAppearMc)
               {
                  ObjectUtils.disposeObject(this._taskAppearMc);
                  this._taskAppearMc = null;
               }
               this._goTaskBtn.alpha = 1;
               this.updateTask();
               break;
            case 2:
               if(this._shopAppearMc)
               {
                  ObjectUtils.disposeObject(this._shopAppearMc);
                  this._shopAppearMc = null;
               }
               this._goShopBtn.alpha = 1;
               break;
            case 3:
               if(this._emailAppearMc)
               {
                  ObjectUtils.disposeObject(this._emailAppearMc);
                  this._emailAppearMc = null;
               }
               this._goEmailBtn.alpha = 1;
               break;
            case 4:
               if(this._friendAppearMc)
               {
                  ObjectUtils.disposeObject(this._friendAppearMc);
                  this._friendAppearMc = null;
               }
               this._goFriendListBtn.alpha = 1;
               break;
            case 5:
               if(this._petAppearMc)
               {
                  ObjectUtils.disposeObject(this._petAppearMc);
                  this._petAppearMc = null;
               }
               this._goPetBtn.alpha = 1;
         }
      }
      
      private function isBitMapAddGrayFilter(param1:Bitmap, param2:Boolean) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!param2)
         {
            param1.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
         }
         else
         {
            param1.filters = null;
         }
      }
      
      private function dispose() : void
      {
         this.removeEvent();
         QuestBubbleManager.Instance.dispose();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function __onReturnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("015");
         if(this._callBackFun != null)
         {
            this._callBackFun();
         }
         else
         {
            StateManager.back();
         }
      }
      
      private function __onExitClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ExitPromptManager.Instance.showView("1");
         NewHandContainer.Instance.clearArrowByID(ArrowType.BACK_GUILDE);
      }
      
      private function __gameSet(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         SettingController.Instance.switchVisible();
      }
      
      private function __onImClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         IMController.Instance.switchVisible();
      }
      
      private function __onChannelClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         GotoPageController.Instance.switchVisible();
      }
      
      private function __onSignClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         this._signEffectEnable = false;
         CalendarManager.getInstance().open(2);
      }
      
      public function set signEffectEnable(param1:Boolean) : void
      {
         this._signEffectEnable = param1;
      }
      
      private function __onEmailClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         this.showEmailShineEffect(false);
         this._unReadEmail = false;
         MailManager.Instance.switchVisible();
      }
      
      private function _overTaskBtn(param1:MouseEvent) : void
      {
         QuestBubbleManager.Instance.addEventListener(QuestBubbleManager.Instance.SHOWTASKTIP,this._showTaskTip);
         QuestBubbleManager.Instance.show();
      }
      
      private function _outTaskBtn(param1:MouseEvent) : void
      {
         QuestBubbleManager.Instance.dispose();
      }
      
      private function _showTaskTip(param1:Event) : void
      {
         QuestBubbleManager.Instance.dispose();
      }
      
      private function __onTaskClick(param1:MouseEvent) : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TASK);
         SoundManager.instance.play("003");
         this._hasClickTaskBtn = true;
         if(this._taskShineEffect && this._taskEffectEnable)
         {
            this._taskEffectEnable = false;
            this.showTaskShineEffect(false);
         }
         QuestBubbleManager.Instance.dispose(true);
         this.showTask();
      }
      
      private function showTask() : void
      {
         TaskManager.instance.switchVisible();
      }
      
      private function __onBagClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("003");
         PlayerManager.Instance.Self.EquipInfo = null;
         BagAndInfoManager.Instance.showBagAndInfo();
      }
      
      private function __onShopClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         if(this.toShopNeedConfirm())
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.room.ToShopConfirm"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            _loc2_.addEventListener(FrameEvent.RESPONSE,this.__confirmToShopResponse);
         }
         else
         {
            StateManager.setState(StateType.SHOP);
         }
         SoundManager.instance.play("003");
      }
      
      private function toShopNeedConfirm() : Boolean
      {
         if(StateManager.currentStateType == StateType.MATCH_ROOM || StateManager.currentStateType == StateType.DUNGEON_ROOM || StateManager.currentStateType == StateType.MISSION_ROOM)
         {
            return true;
         }
         return false;
      }
      
      private function __confirmToShopResponse(param1:FrameEvent) : void
      {
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmToShopResponse);
         ObjectUtils.disposeObject(_loc2_);
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            StateManager.setState(StateType.SHOP);
         }
      }
      
      private function __onSupplyClick(param1:MouseEvent) : void
      {
         LeavePageManager.leaveToFillPath();
      }
      
      public function set unReadEmail(param1:Boolean) : void
      {
         if(param1 == this._unReadEmail)
         {
            return;
         }
         this._unReadEmail = param1;
         if(this._enabled)
         {
            this.updateEmail();
         }
      }
      
      public function set unReadTask(param1:Boolean) : void
      {
         if(this._unReadTask == param1)
         {
            return;
         }
         this._unReadTask = param1;
         if(this._enabled)
         {
            this.updateTask();
         }
      }
      
      public function get unReadTask() : Boolean
      {
         return this._unReadTask;
      }
      
      public function set unReadMovement(param1:Boolean) : void
      {
      }
      
      public function get unReadMovement() : Boolean
      {
         return this._unReadMovement;
      }
      
      private function __updateEmail(param1:EmailEvent) : void
      {
         if(MailManager.Instance.Model.hasUnReadEmail())
         {
            this.unReadEmail = true;
         }
         else
         {
            this.unReadEmail = false;
         }
      }
      
      public function showTaskHightLight() : void
      {
         this.unReadTask = true;
      }
      
      public function hideTaskHightLight() : void
      {
         this.unReadTask = false;
      }
      
      public function showmovementHightLight() : void
      {
         this.unReadMovement = true;
      }
      
      public function setRoomState() : void
      {
         this.setChannelEnable(false);
      }
      
      public function setShopState() : void
      {
         this.setBagEnable(false);
      }
      
      public function setAuctionHouseState() : void
      {
         this.setBagEnable(false);
      }
      
      private function update() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.allBtns.length)
         {
            if(this._enabled)
            {
               if(_loc1_ == 3)
               {
                  this.updateTask();
               }
               else if(_loc1_ == 5)
               {
                  this.updateEmail();
               }
            }
            this.setEnableByIndex(_loc1_,this._enabled);
            _loc1_++;
         }
      }
      
      private function setEnableByIndex(param1:int, param2:Boolean) : void
      {
         if(param1 == 1)
         {
            this.setBagEnable(param2);
         }
         else if(param1 == 4)
         {
            this.setFriendBtnEnable(param2);
         }
         else if(param1 == 5)
         {
            this.setMailEnable(param2);
         }
         else if(param1 == 6)
         {
            this.setChannelEnable(param2);
         }
         else
         {
            this.allBtns[param1].enable = param2;
         }
      }
      
      private function updateTask() : void
      {
         if(this._unReadTask)
         {
            this.showTaskShineEffect(true);
         }
         else
         {
            this.showTaskShineEffect(false);
         }
         this._goTaskBtn.enabled = true;
         this.tipTask();
         TaskDirectorManager.instance.update();
      }
      
      private function updateEmail() : void
      {
         if(!this._goEmailBtn.enabled)
         {
            return;
         }
         if(this._unReadEmail)
         {
            if(MailManager.Instance.Model.hasUnReadEmail())
            {
               this.showEmailShineEffect(true);
            }
            else
            {
               this._unReadEmail = false;
            }
         }
         else
         {
            this.showEmailShineEffect(false);
         }
         this._goEmailBtn.enabled = true;
      }
      
      private function showEmailShineEffect(param1:Boolean) : void
      {
         if(param1)
         {
            this._emailShineEffect.play();
            this._goEmailBtn.alpha = 0;
         }
         else
         {
            this._emailShineEffect.stop();
            this._goEmailBtn.alpha = 1;
         }
      }
      
      private function showFriendShineEffec(param1:Boolean) : void
      {
         if(param1 && this._goFriendListBtn.parent)
         {
            this._friendShineEffec.play();
            this._goFriendListBtn.alpha = 0;
         }
         else
         {
            this._friendShineEffec.stop();
            this._goFriendListBtn.alpha = 1;
         }
      }
      
      private function showTaskShineEffect(param1:Boolean) : void
      {
         if(!SavePointManager.Instance.savePoints[1])
         {
            return;
         }
         if(param1)
         {
            this._taskShineEffect.play();
            this._goTaskBtn.alpha = 0;
            this.tipTask();
         }
         else
         {
            this._taskShineEffect.stop();
            this._goTaskBtn.alpha = 1;
         }
      }
      
      public function __player(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function refresh() : void
      {
      }
      
      private function setChannelEnable(param1:Boolean) : void
      {
         this._goChannelBtn.enabled = param1;
         this._goChannelBtn.mouseEnabled = param1;
         if(param1)
         {
            this._goChannelBtn.filters = null;
         }
         else
         {
            this._goChannelBtn.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
         }
      }
      
      private function setBagEnable(param1:Boolean) : void
      {
         this._goBagBtn.enabled = param1;
         this._goBagBtn.mouseEnabled = param1;
         if(param1)
         {
            this._goBagBtn.filters = null;
         }
         else
         {
            this._goBagBtn.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
         }
      }
      
      private function setFriendBtnEnable(param1:Boolean) : void
      {
         this._goFriendListBtn.enabled = param1;
         if(param1)
         {
            this._goFriendListBtn.filters = null;
         }
         else
         {
            this._goFriendListBtn.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
         }
      }
      
      private function setMailEnable(param1:Boolean) : void
      {
         this._goEmailBtn.enabled = param1;
         this._goEmailBtn.mouseEnabled = param1;
         if(param1)
         {
            this._goEmailBtn.filters = null;
         }
         else
         {
            this._goEmailBtn.filters = ComponentFactory.Instance.creatFilters("grayFilterI");
         }
      }
      
      private function __showArrow(param1:TaskEvent) : void
      {
         if(StateManager.currentStateType != StateType.MAIN)
         {
            NewHandContainer.Instance.showArrow(ArrowType.BACK_GUILDE,-45,"singleDungeon.missionbackArrowPos","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_DYNAMIC_LAYER));
         }
      }
      
      public function tipTask() : void
      {
         var _loc1_:Array = null;
         var _loc2_:uint = 0;
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TASK);
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BAG);
         if(SavePointManager.Instance.isInSavePoint(16) && TaskManager.instance.isNewHandTaskCompleted(12) || SavePointManager.Instance.isInSavePoint(26) && TaskManager.instance.isNewHandTaskCompleted(23) || SavePointManager.Instance.isInSavePoint(67) && TaskManager.instance.isNewHandTaskCompleted(28) || SavePointManager.Instance.savePoints[35] && !SavePointManager.Instance.savePoints[9] && TaskManager.instance.isNewHandTaskCompleted(7))
         {
            NewHandContainer.Instance.clearArrowByID(ArrowType.HALL_BUILD);
         }
         if(StateManager.isInFight || ChurchManager.instance.resposeFrameCount > 0)
         {
            return;
         }
         if(SavePointManager.Instance.isInSavePoint(33) || SavePointManager.Instance.isInSavePoint(64) || SavePointManager.Instance.isInSavePoint(21) && !TaskManager.instance.isNewHandTaskCompleted(17))
         {
            NewHandContainer.Instance.showArrow(ArrowType.CLICK_BAG,0,"trainer.posClickBag","asset.trainer.txtClickEnter","trainer.posClickBagTxt",this);
         }
         if(SavePointManager.Instance.isInSavePoint(3))
         {
            if(!this._hasClickTaskBtn)
            {
               NewHandContainer.Instance.showArrow(ArrowType.CLICK_TASK,0,"trainer.posClickTask","asset.trainer.txtClickEnter","trainer.posClickTaskTxt",this);
            }
         }
         if(!StateManager.isInFight || StateManager.currentStateType != StateType.SINGLEDUNGEON)
         {
            _loc1_ = TaskManager.instance.allCurrentQuest;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(_loc1_[_loc2_].QuestID < 200)
               {
                  if(TaskManager.instance.isCompleted(_loc1_[_loc2_]))
                  {
                     NewHandContainer.Instance.showArrow(ArrowType.CLICK_TASK,0,"trainer.posClickTask","asset.trainer.txtClickEnter","trainer.posClickTaskTxt",MainToolBar.Instance);
                  }
               }
               _loc2_++;
            }
         }
      }
   }
}
