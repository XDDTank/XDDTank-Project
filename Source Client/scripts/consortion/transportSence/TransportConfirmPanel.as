package consortion.transportSence
{
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.HelpFrame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.utils.getTimer;
   import road7th.comm.PackageIn;
   import road7th.utils.StringHelper;
   import room.model.RoomPlayer;
   import room.view.RoomViewerItem;
   
   public class TransportConfirmPanel extends Frame implements Disposeable
   {
       
      
      private var _convoyBeginButton:BaseButton;
      
      private var _BG:Bitmap;
      
      private var _inviteBG:Bitmap;
      
      private var _lookUpUserTextView:TextInput;
      
      private var _scrollListMask:Shape;
      
      private var _memberListScroll:ListPanel;
      
      private var _inviteBtn:TextButton;
      
      private var _searchBtn:SimpleBitmapButton;
      
      private var _isOpenList:Boolean;
      
      private var _rewardContributionTxt:FilterFrameText;
      
      private var _rewardMoneyTxt:FilterFrameText;
      
      private var _rewardContributionTxt2:FilterFrameText;
      
      private var _rewardMoneyTxt2:FilterFrameText;
      
      private var _rewardContributionPlusTxt:FilterFrameText;
      
      private var _rewardMoneyPlusTxt:FilterFrameText;
      
      private var _carI:CarImgContent;
      
      private var _carII:CarImgContent;
      
      private var _currentCarType:int = 1;
      
      private var _guarderItem:RoomViewerItem;
      
      private var _spectatorsBg:Bitmap;
      
      private var _currentInviteName:String;
      
      private var _inviteTime:Number;
      
      private var _btnBg:Scale9CornerImage;
      
      private var _helpFrame:HelpFrame;
      
      public function TransportConfirmPanel()
      {
         super();
         escEnable = true;
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._inviteTime = getTimer();
         titleText = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.convoyComfirmTitle.text");
         SocketManager.Instance.out.SendBuyCar(TransportCar.CARI);
         this._convoyBeginButton = ComponentFactory.Instance.creat("TransportConfirm.convoyBtn");
         this._BG = ComponentFactory.Instance.creatBitmap("TransportConfirm.view.BG");
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("ddtConsortionTransportConfirmPanel.btnBg");
         this._inviteBG = ComponentFactory.Instance.creatBitmap("TransportConfirm.inviteBG");
         this._lookUpUserTextView = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.lookupUserText");
         this._memberListScroll = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionTransport.lookupMemberScroll");
         this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("TransportConfirm.inviteBtn");
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("TransportConfirm.searchBtn");
         this._rewardContributionTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.rewardContributionTxt");
         this._rewardMoneyTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.rewardMoneyTxt");
         this._rewardContributionTxt2 = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.rewardContributionTxt2");
         this._rewardMoneyTxt2 = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.rewardMoneyTxt2");
         this._rewardContributionPlusTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.rewardContributionPlusTxt");
         this._rewardMoneyPlusTxt = ComponentFactory.Instance.creatComponentByStylename("asset.transportConfirm.rewardMoneyPlusTxt");
         this._carI = ComponentFactory.Instance.creatCustomObject("ConsortionTransport.CarImgContentI",[TransportCar.CARI]);
         this._carII = ComponentFactory.Instance.creatCustomObject("ConsortionTransport.CarImgContentII",[TransportCar.CARII]);
         this._scrollListMask = ComponentFactory.Instance.creatCustomObject("transportConfirm.mask");
         this.createMask();
         this._inviteBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionComfirm.inviteBtn.text");
         this._rewardContributionTxt.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text") + ":";
         this._rewardMoneyTxt.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.money.text") + ":";
         var _loc1_:TransportCarInfo = new TransportCarInfo(TransportCar.CARI);
         _loc1_.ownerLevel = PlayerManager.Instance.Self.Grade;
         this._rewardContributionTxt2.text = String(_loc1_.rewardContribution);
         this._rewardMoneyTxt2.text = String(_loc1_.rewardGold);
         this._rewardContributionPlusTxt.text = "(+" + _loc1_.rewardContributionPlus + ")";
         this._rewardMoneyPlusTxt.text = "(+" + _loc1_.rewardGoldPlus + ")";
         this._rewardContributionPlusTxt.visible = false;
         this._rewardMoneyPlusTxt.visible = false;
         this._spectatorsBg = ComponentFactory.Instance.creatBitmap("asset.corei.watch.bg");
         PositionUtils.setPos(this._spectatorsBg,"TransportConfirmPanel.guarderItemBG.pos");
         this._guarderItem = new RoomViewerItem(8,RoomViewerItem.LONG,false);
         PositionUtils.setPos(this._guarderItem,"TransportConfirmPanel.guarderItem.pos");
         addToContent(this._BG);
         addToContent(this._btnBg);
         addToContent(this._inviteBG);
         addToContent(this._carI);
         addToContent(this._carII);
         addToContent(this._convoyBeginButton);
         addToContent(this._guarderItem);
         addToContent(this._rewardContributionTxt);
         addToContent(this._rewardMoneyTxt);
         addToContent(this._rewardContributionTxt2);
         addToContent(this._rewardMoneyTxt2);
         addToContent(this._rewardContributionPlusTxt);
         addToContent(this._rewardMoneyPlusTxt);
         addToContent(this._memberListScroll);
         addToContent(this._scrollListMask);
         addToContent(this._lookUpUserTextView);
         addToContent(this._searchBtn);
         addToContent(this._inviteBtn);
         this._memberListScroll.mask = this._scrollListMask;
         this.addMemberToList();
         this._carI.isSeleted = true;
         var _loc2_:Date = TimeManager.Instance.Now();
         var _loc3_:Number = _loc2_.getHours();
         var _loc4_:Number = _loc2_.getMinutes();
         if(_loc3_ == 17)
         {
            if(_loc4_ >= 30)
            {
               this._rewardContributionPlusTxt.visible = true;
               this._rewardMoneyPlusTxt.visible = true;
            }
         }
         if(_loc3_ == 18)
         {
            this._rewardContributionPlusTxt.visible = true;
            this._rewardMoneyPlusTxt.visible = true;
         }
      }
      
      private function addEvent() : void
      {
         this._convoyBeginButton.addEventListener(MouseEvent.CLICK,this.__beginConvoy);
         this._lookUpUserTextView.addEventListener(TextEvent.TEXT_INPUT,this.__textInputHandler);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__searchMember);
         this._inviteBtn.addEventListener(MouseEvent.CLICK,this.__inviteMember);
         this._carI.addEventListener(MouseEvent.CLICK,this.__chooseCar);
         this._carII.addEventListener(MouseEvent.CLICK,this.__chooseCar);
         TransportManager.Instance.addEventListener(ConsortionEvent.BUY_HIGH_LEVEL_CAR,this.__buyHighLevelCar);
         TransportManager.Instance.addEventListener(ConsortionEvent.GUARDER_IS_LEAVING,this.__guarderIsLeaving);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CONVOY_INVITE_ANSWER,this.__inviteSuccess);
         this._guarderItem.addEventListener(ConsortionEvent.REMOVE_GUARDER,this.__removeGuarder);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function removeEvent() : void
      {
         this._convoyBeginButton.removeEventListener(MouseEvent.CLICK,this.__beginConvoy);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchMember);
         this._inviteBtn.removeEventListener(MouseEvent.CLICK,this.__inviteMember);
         this._carI.removeEventListener(MouseEvent.CLICK,this.__chooseCar);
         this._carII.removeEventListener(MouseEvent.CLICK,this.__chooseCar);
         TransportManager.Instance.removeEventListener(ConsortionEvent.BUY_HIGH_LEVEL_CAR,this.__buyHighLevelCar);
         TransportManager.Instance.removeEventListener(ConsortionEvent.GUARDER_IS_LEAVING,this.__guarderIsLeaving);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONVOY_INVITE_ANSWER,this.__inviteSuccess);
         this._guarderItem.removeEventListener(ConsortionEvent.REMOVE_GUARDER,this.__removeGuarder);
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         if(this._helpFrame)
         {
            this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
         }
      }
      
      private function __guarderIsLeaving(param1:ConsortionEvent) : void
      {
         this._guarderItem.info = null;
      }
      
      private function __removeGuarder(param1:ConsortionEvent) : void
      {
         SocketManager.Instance.out.SendCancleConvoyInvite(PlayerManager.Instance.Self.ID,this._guarderItem.info.playerInfo.ID);
         this._guarderItem.info = null;
      }
      
      private function __textInputHandler(param1:TextEvent) : void
      {
         StringHelper.checkTextFieldLength(this._lookUpUserTextView.textField,14);
      }
      
      private function __buyHighLevelCar(param1:ConsortionEvent) : void
      {
         this._carII.hasBuy = true;
         this._carII.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function addMemberToList() : void
      {
         var _loc1_:Array = ConsortionModelControl.Instance.model.onlineConsortiaMemberList;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_].ID != PlayerManager.Instance.Self.ID && (_loc1_[_loc3_] as ConsortiaPlayerInfo).MaxConvoyTimes - (_loc1_[_loc3_] as ConsortiaPlayerInfo).ConvoyTimes != 0)
            {
               _loc2_.push(_loc1_[_loc3_]);
            }
            _loc3_++;
         }
         this._memberListScroll.vectorListModel.clear();
         this._memberListScroll.vectorListModel.appendAll(_loc2_);
         this._memberListScroll.list.updateListView();
         this._memberListScroll.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__chooseMember);
      }
      
      private function createMask() : void
      {
         this._scrollListMask.graphics.beginFill(0);
         this._scrollListMask.graphics.drawRect(0,0,192,156);
         this._scrollListMask.graphics.endFill();
      }
      
      private function __chooseCar(param1:MouseEvent) : void
      {
         var _loc3_:TransportCarInfo = null;
         SoundManager.instance.play("008");
         var _loc2_:CarImgContent = param1.currentTarget as CarImgContent;
         if(_loc2_.hasBuy)
         {
            switch(_loc2_)
            {
               case this._carI:
                  this._carI.isSeleted = true;
                  this._carII.isSeleted = false;
                  this._currentCarType = TransportCar.CARI;
                  _loc3_ = new TransportCarInfo(TransportCar.CARI);
                  break;
               case this._carII:
                  this._carI.isSeleted = false;
                  this._carII.isSeleted = true;
                  this._currentCarType = TransportCar.CARII;
                  _loc3_ = new TransportCarInfo(TransportCar.CARII);
            }
            _loc3_.ownerLevel = PlayerManager.Instance.Self.Grade;
            this._rewardContributionTxt2.text = String(_loc3_.rewardContribution);
            this._rewardMoneyTxt2.text = String(_loc3_.rewardGold);
            this._rewardContributionPlusTxt.text = "(+" + _loc3_.rewardContributionPlus + ")";
            this._rewardMoneyPlusTxt.text = "(+" + _loc3_.rewardGoldPlus + ")";
         }
      }
      
      private function __chooseMember(param1:ListItemEvent) : void
      {
         var _loc2_:ConsortiaPlayerInfo = param1.cellValue as ConsortiaPlayerInfo;
         this._lookUpUserTextView.text = _loc2_.NickName;
         this.__searchMember(new MouseEvent(MouseEvent.CLICK));
      }
      
      private function __inviteMember(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc5_:ConsortiaPlayerInfo = null;
         SoundManager.instance.play("008");
         if(this._lookUpUserTextView.text == "")
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.inviteNobody.text",15));
            return;
         }
         if(this._currentInviteName == this._lookUpUserTextView.text)
         {
            if(getTimer() - this._inviteTime < 10000)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.inviteSamePersonError.txt",15));
               return;
            }
         }
         if(this._lookUpUserTextView.text == PlayerManager.Instance.Self.NickName)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.inviteMyselfError.txt",15));
            return;
         }
         if(this._guarderItem.info)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.isInvitedError.txt",15));
            return;
         }
         var _loc2_:Array = ConsortionModelControl.Instance.model.onlineConsortiaMemberList;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].NickName == this._lookUpUserTextView.text)
            {
               _loc3_ = _loc2_[_loc4_].ID;
               this._currentInviteName = _loc2_[_loc4_].NickName;
               break;
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            _loc5_ = ConsortionModelControl.Instance.model.getConsortiaMemberInfo(_loc3_);
            if(_loc5_.GuardTruckId != 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.inviteOthersError.text",15));
               return;
            }
            if(_loc5_.GuardTimes >= _loc5_.MaxGuardTimes)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.guarderEndError.text",15));
               return;
            }
            this._inviteTime = getTimer();
            SocketManager.Instance.out.SendInviteConvoy(_loc3_);
         }
         else
         {
            this._currentInviteName = "";
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.inviteError.text",15));
         }
      }
      
      private function __inviteSuccess(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:PlayerInfo = null;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         if(_loc3_)
         {
            _loc5_ = PlayerManager.Instance.findPlayer(_loc4_);
            _loc5_.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__infoChange);
            SocketManager.Instance.out.sendItemEquip(_loc5_.ID);
         }
      }
      
      private function __infoChange(param1:PlayerPropertyEvent) : void
      {
         PlayerInfo(param1.target).removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__infoChange);
         var _loc2_:RoomPlayer = new RoomPlayer(PlayerInfo(param1.target));
         this._guarderItem.info = _loc2_;
      }
      
      private function __searchMember(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         TweenLite.killTweensOf(this._memberListScroll);
         if(this._isOpenList)
         {
            TweenLite.to(this._memberListScroll,0.5,{"y":-64});
            this._isOpenList = false;
         }
         else
         {
            TweenLite.to(this._memberListScroll,0.5,{"y":94});
            this._isOpenList = true;
         }
      }
      
      private function __beginConvoy(param1:MouseEvent) : void
      {
         var _loc2_:TransportCarInfo = null;
         SoundManager.instance.play("008");
         switch(this._currentCarType)
         {
            case TransportCar.CARI:
               _loc2_ = new TransportCarInfo(TransportCar.CARI);
               if(PlayerManager.Instance.Self.Gold < _loc2_.cost)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.goldLess.fail.txt",15));
                  return;
               }
               break;
            case TransportCar.CARII:
               _loc2_ = new TransportCarInfo(TransportCar.CARII);
               if(PlayerManager.Instance.Self.totalMoney < _loc2_.cost)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("consortion.ConsortionComfirm.moneyLess.fail.txt",15));
                  return;
               }
               break;
         }
         SocketManager.Instance.out.SendBeginConvoy(this._currentCarType);
         this.dispose();
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            if(this._guarderItem.info)
            {
               SocketManager.Instance.out.SendCancleConvoyInvite(PlayerManager.Instance.Self.ID,this._guarderItem.info.playerInfo.ID);
            }
            this.dispose();
         }
         if(param1.responseCode == FrameEvent.HELP_CLICK)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("helpFrame");
            this._helpFrame.setView(ComponentFactory.Instance.creat("consortion.HelpFrame.TransferText"));
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
            this._helpFrame.show();
         }
      }
      
      private function __helpResponseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpResponseHandler);
         ObjectUtils.disposeObject(this._helpFrame);
         this._helpFrame = null;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         TweenLite.killTweensOf(this._memberListScroll);
         ObjectUtils.disposeObject(this._convoyBeginButton);
         this._convoyBeginButton = null;
         ObjectUtils.disposeObject(this._BG);
         this._BG = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._inviteBG);
         this._inviteBG = null;
         ObjectUtils.disposeObject(this._lookUpUserTextView);
         this._lookUpUserTextView = null;
         ObjectUtils.disposeObject(this._scrollListMask);
         this._scrollListMask = null;
         ObjectUtils.disposeObject(this._memberListScroll);
         this._memberListScroll = null;
         ObjectUtils.disposeObject(this._inviteBtn);
         this._inviteBtn = null;
         ObjectUtils.disposeObject(this._searchBtn);
         this._searchBtn = null;
         ObjectUtils.disposeObject(this._rewardContributionTxt);
         this._rewardContributionTxt = null;
         ObjectUtils.disposeObject(this._rewardMoneyTxt);
         this._rewardMoneyTxt = null;
         ObjectUtils.disposeObject(this._rewardContributionTxt2);
         this._rewardContributionTxt2 = null;
         ObjectUtils.disposeObject(this._rewardMoneyTxt2);
         this._rewardMoneyTxt2 = null;
         ObjectUtils.disposeObject(this._rewardContributionPlusTxt);
         this._rewardContributionPlusTxt = null;
         ObjectUtils.disposeObject(this._rewardMoneyPlusTxt);
         this._rewardMoneyPlusTxt = null;
         ObjectUtils.disposeObject(this._carI);
         this._carI = null;
         ObjectUtils.disposeObject(this._carII);
         this._carII = null;
         ObjectUtils.disposeObject(this._spectatorsBg);
         this._spectatorsBg = null;
         ObjectUtils.disposeObject(this._guarderItem);
         this._guarderItem = null;
         ObjectUtils.disposeObject(this._helpFrame);
         this._helpFrame = null;
         super.dispose();
      }
   }
}
