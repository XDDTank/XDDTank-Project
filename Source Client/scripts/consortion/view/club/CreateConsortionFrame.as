package consortion.view.club
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.EquipType;
   import ddt.data.analyze.ReworkNameAnalyzer;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   import flash.ui.Keyboard;
   import road7th.utils.StringHelper;
   
   public class CreateConsortionFrame extends Frame
   {
      
      public static const MIN_CREAT_CONSROTIA_LEVEL:int = 13;
      
      public static const MIN_CREAT_CONSORTIA_MONEY:int = 50;
      
      public static const MIN_CREAT_CONSORTIA_GOLD:int = 100000;
       
      
      private var _bg:Bitmap;
      
      private var _input:TextInput;
      
      private var _okBtn:TextButton;
      
      private var _cancelBtn:TextButton;
      
      private var _img:MutipleImage;
      
      private var _conditionText:FilterFrameText;
      
      private var _ticketText1:FilterFrameText;
      
      private var _goldAlertFrame:BaseAlerFrame;
      
      private var _moneyAlertFrame:BaseAlerFrame;
      
      private var _quickBuyFrame:QuickBuyFrame;
      
      public function CreateConsortionFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.titleText");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.createConsortionFrame.BG");
         this._input = ComponentFactory.Instance.creatComponentByStylename("club.createConsortion.input");
         this._img = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.img");
         this._conditionText = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.ticketText2");
         this._conditionText.htmlText = LanguageMgr.GetTranslation("createConsortionFrame.conditionText.Text");
         this._ticketText1 = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.ticketText1");
         this._ticketText1.htmlText = LanguageMgr.GetTranslation("createConsortionFrame.ticketText.Text1");
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.OKBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("ok");
         this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("createConsortionFrame.cancelBtn");
         this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
         addToContent(this._bg);
         addToContent(this._input);
         addToContent(this._img);
         addToContent(this._conditionText);
         addToContent(this._ticketText1);
         addToContent(this._okBtn);
         addToContent(this._cancelBtn);
         this._okBtn.enable = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okFun);
         this._cancelBtn.addEventListener(MouseEvent.CLICK,this.__cancelFun);
         this._input.addEventListener(Event.CHANGE,this.__inputHandler);
         this._input.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyboardHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okFun);
         this._cancelBtn.removeEventListener(MouseEvent.CLICK,this.__cancelFun);
         this._input.removeEventListener(Event.CHANGE,this.__inputHandler);
         this._input.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyboardHandler);
      }
      
      private function createAction() : void
      {
         var _loc3_:BaseAlerFrame = null;
         this._input.text = StringHelper.trim(this._input.text);
         if(PlayerManager.Instance.Self.Money < MIN_CREAT_CONSORTIA_MONEY)
         {
            _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("poorNote"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
            _loc3_.moveEnable = false;
            _loc3_.addEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
            this._okBtn.enable = true;
            return;
         }
         if(!this.checkCanCreatConsortia())
         {
            this._okBtn.enable = true;
            return;
         }
         var _loc1_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         _loc1_["id"] = PlayerManager.Instance.Self.ID;
         _loc1_["NickName"] = this._input.text;
         var _loc2_:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("ConsortiaNameCheck.ashx"),BaseLoader.REQUEST_LOADER,_loc1_);
         _loc2_.analyzer = new ReworkNameAnalyzer(this.checkCallBack);
         _loc2_.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         LoadResourceManager.instance.startLoad(_loc2_);
      }
      
      private function sendName() : void
      {
         SocketManager.Instance.out.sendCreateConsortia(this._input.text);
         this.dispose();
      }
      
      protected function checkCallBack(param1:ReworkNameAnalyzer) : void
      {
         var _loc2_:XML = param1.result;
         if(_loc2_.@value == "true")
         {
            this.sendName();
         }
         else
         {
            this._okBtn.enable = true;
            MessageTipManager.getInstance().show(_loc2_.@message);
         }
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
      }
      
      private function __poorManResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         param1.currentTarget.removeEventListener(FrameEvent.RESPONSE,this.__poorManResponse);
         ObjectUtils.disposeObject(param1.currentTarget);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function __quickBuyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__quickBuyResponse);
         this._goldAlertFrame.dispose();
         this._goldAlertFrame = null;
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            this._quickBuyFrame.itemID = EquipType.GOLD_BOX;
            this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            LayerManager.Instance.addToLayer(this._quickBuyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function checkCanCreatConsortia() : Boolean
      {
         var _loc1_:Array = ["%"];
         if(this._input.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.inputPlease"));
            return false;
         }
         if(PlayerManager.Instance.Self.Grade < MIN_CREAT_CONSROTIA_LEVEL)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.yourGrade"));
            return false;
         }
         if(FilterWordManager.isGotForbiddenWords(this._input.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.consortiaName"));
            return false;
         }
         if(this._input.text.indexOf(_loc1_[0]) > -1)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.CreatConsortiaFrame.consortiaName"));
            return false;
         }
         return true;
      }
      
      private function __addToStageHandler(param1:Event) : void
      {
         this._input.setFocus();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
               this.createAction();
         }
      }
      
      private function __okFun(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._okBtn.enable = false;
         this.createAction();
      }
      
      private function __cancelFun(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      private function __inputHandler(param1:Event) : void
      {
         if(this._input.text != "")
         {
            this._okBtn.enable = true;
         }
         else
         {
            this._okBtn.enable = false;
         }
         StringHelper.checkTextFieldLength(this._input.textField,12);
      }
      
      private function __keyboardHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.createAction();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bg = null;
         this._input = null;
         this._img = null;
         this._conditionText = null;
         this._ticketText1 = null;
         this._okBtn = null;
         this._cancelBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
