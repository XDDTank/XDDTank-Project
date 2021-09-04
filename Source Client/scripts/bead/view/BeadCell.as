package bead.view
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import bead.BeadManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class BeadCell extends BaseCell
   {
       
      
      private var _place:int;
      
      private var _lockBG:Bitmap;
      
      private var _lockIcon:Bitmap;
      
      private var _levelLimit:int;
      
      private var _sPlace:int = -1;
      
      private var _mPlace:int = -1;
      
      private const maxLevel:int = 30;
      
      private var _beadPic:MovieClip;
      
      private var _dragBeadPic:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _circleBg:Bitmap;
      
      private var isExpBead:Boolean;
      
      private var _picDic:Object;
      
      public function BeadCell(param1:int, param2:DisplayObject, param3:ItemTemplateInfo = null, param4:Boolean = true, param5:Boolean = true)
      {
         param2 = Boolean(param2) ? param2 : ComponentFactory.Instance.creatComponentByStylename("asset.beadSystem.beadInset.cellBG");
         super(param2,param3,param4,param5);
         this._place = param1;
         this._picDic = new Object();
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadInsetView.beadCell.name");
         this._nameTxt.mouseEnabled = false;
         this._nameTxt.visible = false;
         addChild(this._nameTxt);
         this._circleBg = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadCell.circleBG");
         this._circleBg.visible = false;
         addChildAt(this._circleBg,0);
         if(param1 >= 0 && param1 < 7)
         {
            this._nameTxt.x = 26;
            this._nameTxt.y = 72;
            param2.x = 20;
            param2.y = 20;
         }
      }
      
      public function lockCell(param1:int) : void
      {
         this._levelLimit = param1;
         this.locked = true;
         this._lockBG = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.holeLock");
         this.addChild(this._lockBG);
         this.info = null;
         filters = null;
      }
      
      public function unlockCell() : void
      {
         this._levelLimit = 0;
         this.locked = false;
         if(this._lockBG)
         {
            ObjectUtils.disposeObject(this._lockBG);
         }
         this._lockBG = null;
         tipStyle = null;
         _tipData = null;
         this.info = null;
      }
      
      public function setBGVisible(param1:Boolean) : void
      {
         this._bg.alpha = !!param1 ? Number(1) : Number(0);
         this._circleBg.visible = !param1;
      }
      
      public function bgVisible(param1:Boolean) : void
      {
         this._bg.alpha = !!param1 ? Number(1) : Number(0);
         this._circleBg.visible = param1;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:InventoryItemInfo = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(param1.data is InventoryItemInfo)
         {
            _loc2_ = param1.data as InventoryItemInfo;
            if(locked)
            {
               if(_loc2_ == this.info)
               {
                  this.locked = false;
                  DragManager.acceptDrag(this);
               }
               else
               {
                  DragManager.acceptDrag(this,DragEffect.NONE);
               }
            }
            else
            {
               param1.action = DragEffect.NONE;
               DragManager.acceptDrag(this);
               if(this._place == 12 && _loc2_.beadIsLock || _loc2_.Place == 12 && this.info && (this.info as InventoryItemInfo).beadIsLock)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.unlock.tip2"));
               }
               else
               {
                  BeadManager.instance.doWhatHandle = 3;
                  PlayerManager.Instance.Self.isBeadUpdate = false;
                  SocketManager.Instance.out.sendBeadMove(_loc2_.Place,this._place);
               }
            }
         }
         else if(param1.source is BeadLockBtn)
         {
            locked = true;
            DragManager.acceptDrag(this);
         }
      }
      
      private function getCombineTip(param1:InventoryItemInfo, param2:InventoryItemInfo) : String
      {
         var _loc12_:int = 0;
         var _loc3_:int = BeadManager.instance.calRequireExp(param2);
         var _loc4_:Object = BeadManager.instance.list;
         var _loc5_:Object = _loc4_[param1.Property2];
         var _loc6_:int = _loc3_ + param1.beadExp;
         var _loc7_:int = param1.beadLevel;
         if(_loc5_)
         {
            _loc12_ = param1.beadLevel + 1;
            while(_loc12_ <= this.maxLevel)
            {
               if(_loc5_[_loc12_.toString()])
               {
                  if(_loc6_ < _loc5_[_loc12_.toString()].Exp)
                  {
                     _loc7_ = int(_loc5_[_loc12_.toString()].Level) - 1;
                     break;
                  }
                  if(_loc12_ == this.maxLevel)
                  {
                     _loc7_ = this.maxLevel;
                  }
               }
               _loc12_++;
            }
         }
         var _loc8_:String = BeadManager.instance.getBeadColorName(param1,int(param2.Property2) != 0,true);
         var _loc9_:String = BeadManager.instance.getBeadColorName(param2,int(param2.Property2) != 0,true);
         var _loc10_:int = Boolean(BeadManager.instance.list[param2.Property2][param2.beadLevel.toString()]) ? int(BeadManager.instance.list[param2.Property2][param2.beadLevel.toString()].SellScore) : int(0);
         var _loc11_:String = LanguageMgr.GetTranslation("beadSystem.bead.combine.tip",_loc8_,_loc9_,_loc3_.toString(),_loc10_ < 0 ? 0 : _loc10_);
         if(_loc7_ > param1.beadLevel)
         {
            _loc11_ += LanguageMgr.GetTranslation("beadSystem.bead.combine.tip2",_loc7_);
         }
         return _loc11_;
      }
      
      protected function onStack(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.onStack);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            BeadManager.instance.combineConfirm(this._mPlace,this.doCombine);
         }
      }
      
      private function doCombine() : void
      {
         BeadManager.instance.doWhatHandle = 1;
         SocketManager.Instance.out.sendBeadCombine(this._sPlace,this._mPlace,!!this.isExpBead ? int(0) : int(1));
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         if(param1.action == DragEffect.MOVE && !param1.target)
         {
            param1.action = DragEffect.NONE;
         }
         this.disposeDragBeadPic();
         this.dragShowPicTxt();
         super.dragStop(param1);
      }
      
      private function discardBead() : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc1_:String = BeadManager.instance.getBeadColorName(info as InventoryItemInfo,true,true);
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("beadSystem.bead.discard.tip",_loc1_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.onStack2,false,0,true);
      }
      
      private function onStack2(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.onStack2);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            BeadManager.instance.doWhatHandle = 4;
            SocketManager.Instance.out.sendBeadDiscardBead(this._place);
         }
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:String = null;
         if(_info)
         {
            tipStyle = null;
            _tipData = null;
            locked = false;
            this.disposeBeadPic();
            this._nameTxt.htmlText = "";
            this._nameTxt.visible = false;
         }
         _info = param1;
         if(param1)
         {
            this.createBeadPic(param1);
            if(int(param1.Property2) == 0)
            {
               _loc2_ = BeadManager.instance.getBeadColorName(param1 as InventoryItemInfo,false);
            }
            else
            {
               _loc2_ = BeadManager.instance.getBeadColorName(param1 as InventoryItemInfo,true,false,"\n");
            }
            this._nameTxt.htmlText = _loc2_;
            this._nameTxt.visible = true;
            this.setChildIndex(this._nameTxt,this.numChildren - 1);
            if(int(param1.Property2) == 0)
            {
               tipStyle = "bead.view.ExpBeadTip";
            }
            else if(this._place == 12)
            {
               tipStyle = "beadSystem.BeadComposeTipPanel";
            }
            else
            {
               tipStyle = "beadSystem.beadTipPanel";
            }
            _tipData = param1;
            if((param1 as InventoryItemInfo).beadIsLock)
            {
               if(this._lockIcon)
               {
                  this._lockIcon.visible = true;
                  setChildIndex(this._lockIcon,numChildren - 1);
               }
               else
               {
                  this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon");
                  if(this._place >= 0 && this._place <= 4)
                  {
                     PositionUtils.setPos(this._lockIcon,"beadInset.lockIcon.pos");
                  }
                  this.addChild(this._lockIcon);
               }
            }
            else if(this._lockIcon)
            {
               this._lockIcon.visible = false;
            }
         }
         else
         {
            if(this._lockIcon)
            {
               this._lockIcon.visible = false;
            }
            if(this._levelLimit > 0 && this._place >= 0 && this._place <= 4)
            {
               tipStyle = "beadSystem.beadLock.tip";
               _tipData = LanguageMgr.GetTranslation("beadSystem.bead.beadLock.tipTxt",this._levelLimit.toString());
            }
         }
      }
      
      public function get levelLimit() : int
      {
         return this._levelLimit;
      }
      
      private function createBeadPic(param1:ItemTemplateInfo) : void
      {
         var _loc2_:MovieClip = null;
         if(int(param1.Property2) < 0 || int(param1.Property2) > 10)
         {
            return;
         }
         if(this._picDic[param1.Property2] == null)
         {
            _loc2_ = ClassUtils.CreatInstance("asset.beadSystem.typeBead" + param1.Property2);
            this._picDic[param1.Property2] = _loc2_;
         }
         else
         {
            _loc2_ = this._picDic[param1.Property2];
         }
         this._beadPic = _loc2_;
         var _loc3_:int = (param1 as InventoryItemInfo).Place;
         if(_loc3_ >= 0 && _loc3_ < 7)
         {
            this._beadPic.scaleX = 52 / 68;
            this._beadPic.scaleY = 52 / 68;
            this._beadPic.x = 24.5;
            this._beadPic.y = 23;
         }
         else
         {
            this._beadPic.scaleX = 52 / 78;
            this._beadPic.scaleY = 52 / 78;
            this._beadPic.x = 5;
            this._beadPic.y = 4.5;
         }
         this._beadPic.visible = true;
         addChild(this._beadPic);
         this._beadPic.gotoAndPlay(1);
      }
      
      override protected function createDragImg() : DisplayObject
      {
         if(this._beadPic)
         {
            this.disposeDragBeadPic();
            this._dragBeadPic = ClassUtils.CreatInstance("asset.beadSystem.typeBead" + _info.Property2);
            this._dragBeadPic.gotoAndPlay(1);
            this._dragBeadPic.scaleX = this._beadPic.scaleX;
            this._dragBeadPic.scaleY = this._beadPic.scaleY;
            return this._dragBeadPic;
         }
         return null;
      }
      
      public function changeLockStatus() : void
      {
         locked = false;
         if(!_info)
         {
            return;
         }
         if(this._place == 12)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.unlock.tip"));
         }
         else
         {
            SocketManager.Instance.out.sendBeadLock(this._place);
         }
      }
      
      override public function dragStart() : void
      {
         if(_info && !locked && stage && _allowDrag)
         {
            if(DragManager.startDrag(this,_info,this.createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               locked = true;
               this.dragHidePicTxt();
            }
         }
      }
      
      override protected function initTip() : void
      {
         tipDirctions = "7,6,2,1,5,4,0,3,6";
         tipGapV = 0;
         tipGapH = 0;
      }
      
      private function dragHidePicTxt() : void
      {
         this._beadPic.visible = false;
         this._nameTxt.visible = false;
         if(this._lockIcon)
         {
            this._lockIcon.visible = false;
         }
      }
      
      private function dragShowPicTxt() : void
      {
         this._beadPic.visible = true;
         this._nameTxt.visible = true;
         if((_info as InventoryItemInfo).beadIsLock && this._lockIcon)
         {
            this._lockIcon.visible = true;
         }
      }
      
      private function disposeDragBeadPic() : void
      {
         if(this._dragBeadPic)
         {
            this._dragBeadPic.gotoAndStop(this._dragBeadPic.totalFrames);
            ObjectUtils.disposeObject(this._dragBeadPic);
            this._dragBeadPic = null;
         }
      }
      
      private function disposeBeadPic() : void
      {
         if(this._beadPic)
         {
            this._beadPic.gotoAndStop(this._beadPic.totalFrames);
            ObjectUtils.disposeObject(this._beadPic);
            this._beadPic = null;
         }
      }
      
      override public function dispose() : void
      {
         this.disposeBeadPic();
         if(this._nameTxt)
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(this._circleBg)
         {
            ObjectUtils.disposeObject(this._circleBg);
         }
         this._circleBg = null;
         if(this._lockBG)
         {
            ObjectUtils.disposeObject(this._lockBG);
         }
         this._lockBG = null;
         if(this._lockIcon)
         {
            ObjectUtils.disposeObject(this._lockIcon);
         }
         this._lockIcon = null;
         this._picDic = null;
         super.dispose();
      }
   }
}
