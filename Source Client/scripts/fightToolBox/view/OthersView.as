package fightToolBox.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.controls.list.DropList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.view.FriendDropListTarget;
   import ddt.view.chat.ChatFriendListPanel;
   import fightToolBox.FightToolBoxController;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Point;
   import road7th.utils.StringHelper;
   
   public class OthersView extends Sprite implements Disposeable
   {
       
      
      private var _nametxt:FilterFrameText;
      
      private var _repeatNametxt:FilterFrameText;
      
      private var _friendName:FriendDropListTarget;
      
      private var _amountOfMoneyTxt:FilterFrameText;
      
      private var _amountOfMoney:FilterFrameText;
      
      private var _moneyIcon:Image;
      
      private var _dropList:DropList;
      
      private var _repeatName:TextInput;
      
      private var _friendListBtn:TextButton;
      
      private var _friendList:ChatFriendListPanel;
      
      private var _list:VBox;
      
      private var _itemArray:Array;
      
      private var _listBG:Scale9CornerImage;
      
      private var _inputBG:Scale9CornerImage;
      
      private var _listScrollPanel:ScrollPanel;
      
      private var _payNum:int;
      
      private var _level:int;
      
      private var _confirmFrame:BaseAlerFrame;
      
      private var _moneyConfirm:BaseAlerFrame;
      
      public function OthersView()
      {
         super();
         this.iniView();
         this.intEvent();
      }
      
      private function iniView() : void
      {
         this._nametxt = ComponentFactory.Instance.creatComponentByStylename("FightToolBox.name");
         this._nametxt.text = LanguageMgr.GetTranslation("FightToolBox.nametxt");
         addChild(this._nametxt);
         this._repeatNametxt = ComponentFactory.Instance.creatComponentByStylename("FightToolBox.repeatName");
         this._repeatNametxt.text = LanguageMgr.GetTranslation("FightToolBox.repeatNametxt");
         addChild(this._repeatNametxt);
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("asset.FightToolBox.friendNameBG");
         addChild(this._inputBG);
         this._friendName = ComponentFactory.Instance.creat("othersView.friendName");
         addChild(this._friendName);
         this._dropList = ComponentFactory.Instance.creatComponentByStylename("othersView.DropList");
         this._dropList.targetDisplay = this._friendName;
         this._dropList.x = this._inputBG.x;
         this._dropList.y = this._inputBG.y + this._inputBG.height;
         this._repeatName = ComponentFactory.Instance.creatComponentByStylename("othersView.repeatName");
         addChild(this._repeatName);
         this._friendListBtn = ComponentFactory.Instance.creatComponentByStylename("othersView.friendList");
         this._friendListBtn.text = LanguageMgr.GetTranslation("FightToolBox.friendListBtn");
         addChild(this._friendListBtn);
         this._friendList = new ChatFriendListPanel();
         this._friendList.setup(this.selectName);
         this._list = ComponentFactory.Instance.creatComponentByStylename("othersView.searchList");
         addChild(this._list);
         this._itemArray = new Array();
         this._amountOfMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("othersView.amountOfMoneyTxt");
         this._amountOfMoneyTxt.text = LanguageMgr.GetTranslation("FightToolBox.amountOfMoneyTxt");
         addChild(this._amountOfMoneyTxt);
         this._amountOfMoney = ComponentFactory.Instance.creatComponentByStylename("othersView.amountOfMoney");
         this._amountOfMoney.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("FightToolBox.amountOfMoneyUnit");
         addChild(this._amountOfMoney);
         this._moneyIcon = ComponentFactory.Instance.creatComponentByStylename("othersView.MoneyIcon");
         addChild(this._moneyIcon);
      }
      
      private function intEvent() : void
      {
         this._friendName.addEventListener(TextEvent.TEXT_INPUT,this.__textInputHandler);
         this._friendName.addEventListener(Event.CHANGE,this.__textChange);
         this._repeatName.addEventListener(TextEvent.TEXT_INPUT,this.__repeattextInputHandler);
         this._friendListBtn.addEventListener(MouseEvent.CLICK,this.__friendListView);
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this.__listAction);
         this._friendName.addEventListener(FocusEvent.FOCUS_IN,this.__textChange);
         this._dropList.addEventListener(DropList.SELECTED,this.__seletected);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChangedHandler);
      }
      
      private function __seletected(param1:Event) : void
      {
         this._repeatName.text = this._friendName.text;
      }
      
      protected function __propertyChangedHandler(param1:Event) : void
      {
         this._amountOfMoney.text = PlayerManager.Instance.Self.Money + LanguageMgr.GetTranslation("FightToolBox.amountOfMoneyUnit");
      }
      
      private function __textInputHandler(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._friendName,14);
      }
      
      private function __textChange(param1:Event) : void
      {
         if(this._friendName.text == "")
         {
            this._dropList.dataList = null;
            return;
         }
         var _loc2_:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
         this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(_loc2_),this._friendName.text);
      }
      
      private function filterSearch(param1:Array, param2:String) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param1[_loc4_].NickName.indexOf(param2) != -1)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function filterRepeatInArray(param1:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(_loc3_ == 0)
            {
               _loc2_.push(param1[_loc3_]);
            }
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_].NickName == param1[_loc3_].NickName)
               {
                  break;
               }
               if(_loc4_ == _loc2_.length - 1)
               {
                  _loc2_.push(param1[_loc3_]);
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function __repeattextInputHandler(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._repeatName.textField,14);
      }
      
      private function __friendListView(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         SoundManager.instance.play("008");
         _loc2_ = this._friendListBtn.localToGlobal(new Point(0,0));
         this._friendList.x = _loc2_.x;
         this._friendList.y = _loc2_.y + this._friendListBtn.height;
         this._friendList.setVisible = true;
      }
      
      public function sendOpen(param1:int) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         switch(param1)
         {
            case 0:
               this._level = FightToolBoxController.instance.model.fightVipTime_high;
               this._payNum = FightToolBoxController.instance.model.fightVipPrice_high;
               break;
            case 1:
               this._level = FightToolBoxController.instance.model.fightVipTime_mid;
               this._payNum = FightToolBoxController.instance.model.fightVipPrice_mid;
               break;
            case 2:
               this._level = FightToolBoxController.instance.model.fightVipTime_low;
               this._payNum = FightToolBoxController.instance.model.fightVipPrice_low;
         }
         if(PlayerManager.Instance.Self.Money < this._payNum)
         {
            this._moneyConfirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            this._moneyConfirm.moveEnable = false;
            this._moneyConfirm.addEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
            return;
         }
         if(this._friendName.text == "" || this._repeatName.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("FightToolBox.othersView.finish"));
            return;
         }
         if(this._friendName.text != this._repeatName.text)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("FightToolBox.othersView.checkName"));
            return;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("FightToolBox.othersView.confirmforOther",this._friendName.text,this._level,this._payNum);
         this._confirmFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("FightToolBox.ConfirmTitle"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.BLCAK_BLOCKGOUND);
         this._confirmFrame.moveEnable = false;
         this._confirmFrame.addEventListener(FrameEvent.RESPONSE,this.__confirm);
      }
      
      private function __moneyConfirmHandler(param1:FrameEvent) : void
      {
         this._moneyConfirm.removeEventListener(FrameEvent.RESPONSE,this.__moneyConfirmHandler);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               LeavePageManager.leaveToFillPath();
         }
         this._moneyConfirm.dispose();
         if(this._moneyConfirm.parent)
         {
            this._moneyConfirm.parent.removeChild(this._moneyConfirm);
         }
         this._moneyConfirm = null;
      }
      
      private function __confirm(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._confirmFrame.removeEventListener(FrameEvent.RESPONSE,this.__confirm);
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               FightToolBoxController.instance.sendOpen(this._friendName.text,this._level);
               this._friendName.text = "";
               this._repeatName.text = "";
         }
         this._confirmFrame.dispose();
         if(this._confirmFrame.parent)
         {
            this._confirmFrame.parent.removeChild(this._confirmFrame);
         }
      }
      
      private function __listAction(param1:MouseEvent) : void
      {
         if(param1.target is FriendDropListTarget)
         {
            return;
         }
         if(this._dropList && this._dropList.parent)
         {
            this._dropList.parent.removeChild(this._dropList);
         }
      }
      
      private function selectName(param1:String, param2:int = 0) : void
      {
         this._friendName.text = param1;
         this._repeatName.text = param1;
         this._friendList.setVisible = false;
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function dispose() : void
      {
         this._friendName.removeEventListener(TextEvent.TEXT_INPUT,this.__textInputHandler);
         this._friendName.removeEventListener(Event.CHANGE,this.__textChange);
         this._repeatName.removeEventListener(TextEvent.TEXT_INPUT,this.__repeattextInputHandler);
         this._friendListBtn.removeEventListener(MouseEvent.CLICK,this.__friendListView);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this.__listAction);
         this._friendName.removeEventListener(FocusEvent.FOCUS_IN,this.__textChange);
         this._dropList.removeEventListener(DropList.SELECTED,this.__seletected);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChangedHandler);
         if(this._nametxt)
         {
            ObjectUtils.disposeObject(this._nametxt);
         }
         this._nametxt = null;
         if(this._repeatNametxt)
         {
            ObjectUtils.disposeObject(this._repeatNametxt);
         }
         this._repeatNametxt = null;
         if(this._friendName)
         {
            ObjectUtils.disposeObject(this._friendName);
         }
         this._friendName = null;
         if(this._amountOfMoneyTxt)
         {
            ObjectUtils.disposeObject(this._amountOfMoneyTxt);
         }
         this._amountOfMoneyTxt = null;
         if(this._amountOfMoney)
         {
            ObjectUtils.disposeObject(this._amountOfMoney);
         }
         this._amountOfMoney = null;
         if(this._moneyIcon)
         {
            ObjectUtils.disposeObject(this._moneyIcon);
         }
         this._moneyIcon = null;
         if(this._dropList)
         {
            ObjectUtils.disposeObject(this._dropList);
         }
         this._dropList = null;
         if(this._repeatName)
         {
            ObjectUtils.disposeObject(this._repeatName);
         }
         this._repeatName = null;
         if(this._friendListBtn)
         {
            ObjectUtils.disposeObject(this._friendListBtn);
         }
         this._friendListBtn = null;
         if(this._friendList)
         {
            ObjectUtils.disposeObject(this._friendList);
         }
         this._friendList = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         if(this._itemArray)
         {
            ObjectUtils.disposeObject(this._itemArray);
         }
         this._itemArray = null;
         if(this._inputBG)
         {
            ObjectUtils.disposeObject(this._inputBG);
         }
         this._inputBG = null;
         if(this._listScrollPanel)
         {
            ObjectUtils.disposeObject(this._listScrollPanel);
         }
         this._listScrollPanel = null;
         if(this._confirmFrame)
         {
            this._confirmFrame.dispose();
         }
         this._confirmFrame = null;
         if(this._moneyConfirm)
         {
            this._moneyConfirm.dispose();
         }
         this._moneyConfirm = null;
      }
   }
}
