package consortion.view.selfConsortia
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortiaApplyInfo;
   import consortion.event.ConsortionEvent;
   import ddt.data.player.ConsortiaPlayerInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ApplyList extends Sprite implements Disposeable
   {
       
      
      private var _Bg:MutipleImage;
      
      private var _nameBtn:SelectedCheckButton;
      
      private var _levelTxt:FilterFrameText;
      
      private var _powerTxt:FilterFrameText;
      
      private var _operateTxt:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _list:ScrollPanel;
      
      private var _menberListVLine:MutipleImage;
      
      private var _agree:TextButton;
      
      private var _refuse:TextButton;
      
      private var _downBg:MutipleImage;
      
      private var _disband:TextButton;
      
      private var _transfer:TextButton;
      
      private var _buildGradeBtn:BaseButton;
      
      private var _items:Array;
      
      public function ApplyList()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function show() : void
      {
         this.visible = true;
         this._nameBtn.selected = false;
      }
      
      private function initView() : void
      {
         this._Bg = ComponentFactory.Instance.creatComponentByStylename("memberlist.Bg");
         this._menberListVLine = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInMemberListVLine");
         PositionUtils.setPos(this._menberListVLine,"asset.ddtconsortion.applyTilteLine");
         this._nameBtn = ComponentFactory.Instance.creatComponentByStylename("ddtClubView.MemberInSelectedbtn");
         this._nameBtn.text = LanguageMgr.GetTranslation("itemview.listname");
         this._nameBtn.selected = false;
         this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.levelTxt");
         this._levelTxt.text = LanguageMgr.GetTranslation("itemview.listlevel");
         this._powerTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeInItem.powerTxt");
         this._powerTxt.text = LanguageMgr.GetTranslation("itemview.listfightpower");
         this._operateTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.operateTxt");
         this._operateTxt.text = LanguageMgr.GetTranslation("operate");
         this._agree = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.agreeBtn");
         this._agree.text = LanguageMgr.GetTranslation("consortion.takeIn.agreeBtn.text");
         this._refuse = ComponentFactory.Instance.creatComponentByStylename("consortion.takeIn.refuseBtn");
         this._refuse.text = LanguageMgr.GetTranslation("consortion.takeIn.refuseBtn.text");
         PositionUtils.setPos(this._levelTxt,"asset.ddtconsortion.applyLevelTxt");
         PositionUtils.setPos(this._powerTxt,"asset.ddtconsortion.applypowerTxt");
         PositionUtils.setPos(this._operateTxt,"asset.ddtconsortion.applyoperateTxt");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.applyVbox");
         this._list = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.applyPanel");
         this._list.setView(this._vbox);
         this._downBg = ComponentFactory.Instance.creatComponentByStylename("ddtconsortion.applylistDownBG");
         this._disband = ComponentFactory.Instance.creatComponentByStylename("buildingManager.exit");
         this._disband.text = LanguageMgr.GetTranslation("ddt.consortion.buildingManager.exit");
         this._transfer = ComponentFactory.Instance.creatComponentByStylename("buildingManager.exit");
         this._transfer.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.AlienationConsortiaFrame.titleText");
         PositionUtils.setPos(this._disband,"asset.ddtconsortion.applydisbandBtn");
         PositionUtils.setPos(this._transfer,"asset.ddtconsortion.applytransferBtn");
         this._buildGradeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtroomconsortion.buildingupgradesBtn");
         addChild(this._Bg);
         addChild(this._menberListVLine);
         addChild(this._nameBtn);
         addChild(this._levelTxt);
         addChild(this._powerTxt);
         addChild(this._operateTxt);
         addChild(this._list);
         addChild(this._downBg);
         addChild(this._disband);
         addChild(this._refuse);
         addChild(this._agree);
         addChild(this._transfer);
         addChild(this._buildGradeBtn);
         this.initRight();
      }
      
      private function initRight() : void
      {
         if(PlayerManager.Instance.Self.DutyLevel == 1)
         {
            this._disband.enable = true;
            this._transfer.enable = true;
         }
         else
         {
            this._disband.enable = false;
            this._transfer.enable = false;
         }
      }
      
      private function clearList() : void
      {
         var _loc1_:int = 0;
         this._vbox.disposeAllChildren();
         if(this._items)
         {
            _loc1_ = 0;
            while(_loc1_ < this._items.length)
            {
               this._items[_loc1_] = null;
               _loc1_++;
            }
            this._items = null;
         }
         this._items = new Array();
      }
      
      private function initEvent() : void
      {
         ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__eventChangeHandler);
         this._nameBtn.addEventListener(MouseEvent.CLICK,this._selectAll);
         this._agree.addEventListener(MouseEvent.CLICK,this.__agree);
         this._refuse.addEventListener(MouseEvent.CLICK,this.__refuse);
         this._transfer.addEventListener(MouseEvent.CLICK,this.__transfer);
         this._disband.addEventListener(MouseEvent.CLICK,this.__disband);
         this._buildGradeBtn.addEventListener(MouseEvent.CLICK,this.__buildGrade);
      }
      
      private function removeEvent() : void
      {
         ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.MY_APPLY_LIST_IS_CHANGE,this.__eventChangeHandler);
         this._nameBtn.removeEventListener(MouseEvent.CLICK,this._selectAll);
         this._agree.removeEventListener(MouseEvent.CLICK,this.__agree);
         this._refuse.removeEventListener(MouseEvent.CLICK,this.__refuse);
         this._transfer.removeEventListener(MouseEvent.CLICK,this.__transfer);
         this._disband.removeEventListener(MouseEvent.CLICK,this.__disband);
         this._buildGradeBtn.removeEventListener(MouseEvent.CLICK,this.__buildGrade);
      }
      
      private function __eventChangeHandler(param1:ConsortionEvent) : void
      {
         var _loc5_:TakeInMemberItem = null;
         this.clearList();
         var _loc2_:Vector.<ConsortiaApplyInfo> = ConsortionModelControl.Instance.model.myApplyList;
         var _loc3_:int = _loc2_.length;
         var _loc4_:int = 0;
         if(_loc3_ == 0)
         {
            while(_loc4_ < 9)
            {
               _loc5_ = new TakeInMemberItem();
               _loc5_.updateBaceGroud(_loc4_);
               this._vbox.addChild(_loc5_);
               _loc4_++;
            }
         }
         else if(_loc3_ >= 9)
         {
            while(_loc4_ < _loc3_)
            {
               _loc5_ = new TakeInMemberItem();
               _loc5_.updateBaceGroud(_loc4_);
               _loc5_.info = _loc2_[_loc4_];
               this._vbox.addChild(_loc5_);
               this._items.push(_loc5_);
               _loc4_++;
            }
         }
         else
         {
            while(_loc4_ < 9)
            {
               if(_loc4_ < _loc3_)
               {
                  _loc5_ = new TakeInMemberItem();
                  _loc5_.updateBaceGroud(_loc4_);
                  _loc5_.info = _loc2_[_loc4_];
                  this._vbox.addChild(_loc5_);
                  this._items.push(_loc5_);
               }
               else
               {
                  _loc5_ = new TakeInMemberItem();
                  _loc5_.updateBaceGroud(_loc4_);
                  this._vbox.addChild(_loc5_);
               }
               _loc4_++;
            }
         }
         this._list.invalidateViewport();
      }
      
      private function _selectAll(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         SoundManager.instance.play("008");
         if(this.allHasSelected() && !this._nameBtn.selected)
         {
            _loc2_ = 0;
            while(_loc2_ < this._items.length)
            {
               if(this._items[_loc2_])
               {
                  (this._items[_loc2_] as TakeInMemberItem).selected = false;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this._items.length)
            {
               if(this._items[_loc3_])
               {
                  (this._items[_loc3_] as TakeInMemberItem).selected = true;
               }
               _loc3_++;
            }
         }
      }
      
      private function allHasSelected() : Boolean
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this._items.length)
         {
            if(!(this._items[_loc1_] as TakeInMemberItem).selected)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function __agree(param1:MouseEvent) : void
      {
         var _loc4_:TakeInMemberItem = null;
         SoundManager.instance.play("008");
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this._items.length)
         {
            _loc4_ = this._items[_loc3_] as TakeInMemberItem;
            if(_loc4_)
            {
               if(_loc4_.selected)
               {
                  SocketManager.Instance.out.sendConsortiaTryinPass(_loc4_.info.ID);
                  _loc2_ = false;
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
         }
      }
      
      private function __refuse(param1:MouseEvent) : void
      {
         var _loc4_:TakeInMemberItem = null;
         SoundManager.instance.play("008");
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this._items.length)
         {
            _loc4_ = this._items[_loc3_] as TakeInMemberItem;
            if(_loc4_)
            {
               if((this._items[_loc3_] as TakeInMemberItem).selected)
               {
                  SocketManager.Instance.out.sendConsortiaTryinDelete(_loc4_.info.ID);
                  _loc2_ = false;
               }
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.AtLeastChoose"));
         }
      }
      
      private function __transfer(param1:MouseEvent) : void
      {
         var _loc3_:ConsortionTrasferFrame = null;
         SoundManager.instance.play("008");
         var _loc2_:Vector.<ConsortiaPlayerInfo> = ConsortionModelControl.Instance.model.ViceChairmanConsortiaMemberList;
         if(_loc2_.length == 0)
         {
            return MessageTipManager.getInstance().show("暂无副会长,无法转让公会");
         }
         _loc3_ = ComponentFactory.Instance.creatComponentByStylename("consortionTrasferFrame");
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function __disband(param1:MouseEvent) : void
      {
         var _loc2_:ConsortionDisbandFrame = null;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ConsortionDisbandFrame");
         _loc2_.show();
         _loc2_.setInputTxtFocus();
      }
      
      private function __buildGrade(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:ConsortionUpGradeFrame = ComponentFactory.Instance.creatComponentByStylename("consortionUpGradeFrame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function dispose() : void
      {
         this.clearList();
         this.removeEvent();
         if(this._vbox)
         {
            this._vbox.disposeAllChildren();
            ObjectUtils.disposeObject(this._vbox);
         }
         if(this._Bg)
         {
            ObjectUtils.disposeObject(this._Bg);
         }
         this._Bg = null;
         if(this._menberListVLine)
         {
            ObjectUtils.disposeObject(this._menberListVLine);
         }
         this._menberListVLine = null;
         if(this._nameBtn)
         {
            ObjectUtils.disposeObject(this._nameBtn);
         }
         this._nameBtn = null;
         if(this._levelTxt)
         {
            ObjectUtils.disposeObject(this._levelTxt);
         }
         this._levelTxt = null;
         if(this._powerTxt)
         {
            ObjectUtils.disposeObject(this._powerTxt);
         }
         this._powerTxt = null;
         if(this._operateTxt)
         {
            ObjectUtils.disposeObject(this._operateTxt);
         }
         this._operateTxt = null;
         if(this._agree)
         {
            ObjectUtils.disposeObject(this._agree);
         }
         this._agree = null;
         if(this._refuse)
         {
            ObjectUtils.disposeObject(this._refuse);
         }
         this._refuse = null;
         if(this._downBg)
         {
            ObjectUtils.disposeObject(this._downBg);
         }
         this._downBg = null;
         if(this._disband)
         {
            ObjectUtils.disposeObject(this._disband);
         }
         this._disband = null;
         if(this._transfer)
         {
            ObjectUtils.disposeObject(this._transfer);
         }
         this._transfer = null;
         if(this._buildGradeBtn)
         {
            ObjectUtils.disposeObject(this._buildGradeBtn);
         }
         this._buildGradeBtn = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         ObjectUtils.disposeAllChildren(this);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
