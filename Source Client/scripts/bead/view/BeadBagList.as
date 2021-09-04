package bead.view
{
   import baglocked.BaglockedManager;
   import bead.BeadManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.ProgressBar;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   import road7th.utils.MovieClipWrapper;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class BeadBagList extends Sprite implements Disposeable
   {
       
      
      private const EquipBagStartPlace:int = 0;
      
      private const EquipBagEndPlace:int = 4;
      
      private const BeadBagStartPlace:int = 12;
      
      private const BeadBagEndPlace:int = 27;
      
      private var _beadList:Dictionary;
      
      private var _beadBag:BagInfo;
      
      private var _levelLimitData:Array;
      
      private var _beadPowerTxt:BeadPowerText;
      
      private var _combineOnekeyCellLight:MovieClip;
      
      private var _recordExp:int;
      
      private var _splitBtn:TextButton;
      
      private var _sellSmallBg:Bitmap;
      
      private var _progressBar:ProgressBar;
      
      private var _isLock:Boolean;
      
      public function BeadBagList()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function get beadList() : Dictionary
      {
         return this._beadList;
      }
      
      private function initEvent() : void
      {
         this._beadBag.addEventListener(BagEvent.UPDATE,this.updateBeadCell,false,0,true);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__lockChange);
      }
      
      private function initView() : void
      {
         var _loc5_:BeadCell = null;
         var _loc6_:int = 0;
         var _loc7_:BeadCell = null;
         this._beadBag = PlayerManager.Instance.Self.getBag(BagInfo.BEADBAG);
         this._beadList = new Dictionary();
         var _loc1_:String = BeadManager.instance.beadConfig.GemHoleNeedLevel;
         this._levelLimitData = _loc1_.split("|");
         var _loc2_:int = PlayerManager.Instance.Self.Grade;
         var _loc3_:int = this.EquipBagStartPlace;
         while(_loc3_ <= this.EquipBagEndPlace)
         {
            _loc5_ = ComponentFactory.Instance.creatCustomObject("equipBeadCell_" + _loc3_,[_loc3_,null]);
            _loc5_.addEventListener(InteractiveEvent.CLICK,this.startBeadDrag,false,0,true);
            _loc5_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.doubleClickHandler,false,0,true);
            DoubleClickManager.Instance.enableDoubleClick(_loc5_);
            addChild(_loc5_);
            this._beadList[_loc3_] = _loc5_;
            _loc5_.info = this._beadBag.items[_loc3_];
            _loc5_.setBGVisible(false);
            _loc6_ = int(this._levelLimitData[_loc3_]);
            if(_loc2_ < _loc6_ || _loc6_ == -1)
            {
               _loc5_.lockCell(_loc6_);
            }
            _loc3_++;
         }
         var _loc4_:int = this.BeadBagStartPlace;
         while(_loc4_ <= this.BeadBagEndPlace)
         {
            _loc7_ = new BeadCell(_loc4_,null);
            if(_loc4_ == this.BeadBagStartPlace)
            {
               PositionUtils.setPos(_loc7_,"bead.beadcell.centpos");
               _loc7_.bgVisible(false);
            }
            else
            {
               _loc7_.x = (_loc4_ - 13) % 5 * (12.5 + _loc7_.width) - 4;
               _loc7_.y = int((_loc4_ - 13) / 5) * (8 + _loc7_.height) - 52;
            }
            _loc7_.addEventListener(InteractiveEvent.CLICK,this.startBeadDrag,false,0,true);
            _loc7_.addEventListener(InteractiveEvent.DOUBLE_CLICK,this.doubleClickHandler,false,0,true);
            DoubleClickManager.Instance.enableDoubleClick(_loc7_);
            addChild(_loc7_);
            this._beadList[_loc4_] = _loc7_;
            _loc7_.info = this._beadBag.items[_loc4_];
            _loc4_++;
         }
         this._beadPowerTxt = ComponentFactory.Instance.creatCustomObject("beadInsetView.beadPower.txt");
         this.refreshBeadPowerTxt();
         addChild(this._beadPowerTxt);
         this._combineOnekeyCellLight = ComponentFactory.Instance.creat("asset.core.beadCellShine");
         this._combineOnekeyCellLight.x = -6;
         this._combineOnekeyCellLight.y = -6;
         this._combineOnekeyCellLight.scaleX = 1.2;
         this._combineOnekeyCellLight.scaleY = 1.2;
         this._combineOnekeyCellLight.gotoAndStop(1);
         this._beadList[12].addChild(this._combineOnekeyCellLight);
         this.playExpTipHandler(false);
         if(this._beadBag.items[this.BeadBagStartPlace])
         {
            this.showSplitSellBtn();
         }
         this._progressBar = ComponentFactory.Instance.creatComponentByStylename("beadSystem.BeadProgressBar");
         addChild(this._progressBar);
         this.updateProgress(this._beadBag.items[this.BeadBagStartPlace]);
      }
      
      private function __lockChange(param1:PlayerPropertyEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1.changedProperties["Grade"])
         {
            _loc2_ = PlayerManager.Instance.Self.Grade;
            _loc3_ = this.EquipBagStartPlace;
            while(_loc3_ <= this.EquipBagEndPlace)
            {
               _loc4_ = int(this._levelLimitData[_loc3_]);
               if(_loc4_ != -1 && _loc2_ >= _loc4_ && this._beadList[_loc3_].locked)
               {
                  this._beadList[_loc3_].unlockCell();
               }
               _loc3_++;
            }
         }
      }
      
      private function openBeadPlace(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("beadSystem.bead.vipBeadUnlock.tip"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc2_.addEventListener(FrameEvent.RESPONSE,this.onStack,false,0,true);
      }
      
      private function onStack(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.onStack);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money < 9980)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            this.openVipBeadHandler(null);
         }
      }
      
      private function openVipBeadHandler(param1:CrazyTankSocketEvent) : void
      {
         if(this._beadList[5])
         {
            (this._beadList[5] as BeadCell).buttonMode = false;
            (this._beadList[5] as BeadCell).removeEventListener(MouseEvent.CLICK,this.openBeadPlace);
            (this._beadList[5] as BeadCell).unlockCell();
         }
      }
      
      private function doubleClickHandler(param1:InteractiveEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         if(this._isLock)
         {
            return;
         }
         var _loc2_:BeadCell = param1.currentTarget as BeadCell;
         if(!_loc2_.info || _loc2_.locked)
         {
            return;
         }
         SoundManager.instance.play("008");
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
         var _loc3_:int = (_loc2_.info as InventoryItemInfo).Place;
         var _loc4_:DictionaryData = this._beadBag.items as DictionaryData;
         var _loc5_:int = -1;
         if(_loc3_ >= this.EquipBagStartPlace && _loc3_ <= this.EquipBagEndPlace)
         {
            _loc6_ = 13;
            while(_loc6_ <= this.BeadBagEndPlace)
            {
               if(!_loc4_[_loc6_])
               {
                  _loc5_ = _loc6_;
                  break;
               }
               _loc6_++;
            }
         }
         else if(_loc3_ >= this.BeadBagStartPlace && _loc3_ <= this.BeadBagEndPlace)
         {
            _loc7_ = this.EquipBagStartPlace;
            while(_loc7_ <= this.EquipBagEndPlace)
            {
               if((this._beadList[_loc7_] as BeadCell).levelLimit == 0 && !_loc4_[_loc7_])
               {
                  _loc5_ = _loc7_;
                  break;
               }
               _loc7_++;
            }
         }
         if(_loc5_ == -1)
         {
            if(_loc3_ >= this.EquipBagStartPlace && _loc3_ <= this.EquipBagEndPlace)
            {
               _loc8_ = LanguageMgr.GetTranslation("beadSystem.bead.move.tip");
            }
            else
            {
               _loc8_ = LanguageMgr.GetTranslation("beadSystem.bead.move.tip2");
            }
            MessageTipManager.getInstance().show(_loc8_);
         }
         else
         {
            _loc2_.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
            BeadManager.instance.doWhatHandle = 3;
            PlayerManager.Instance.Self.isBeadUpdate = false;
            SocketManager.Instance.out.sendBeadMove(_loc3_,_loc5_);
         }
      }
      
      private function updateBeadCell(param1:BagEvent) : void
      {
         var _loc3_:InventoryItemInfo = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:InventoryItemInfo = null;
         var _loc2_:Dictionary = param1.changedSlots;
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = _loc3_.Place;
            if(_loc5_ >= this.EquipBagStartPlace && _loc5_ <= this.EquipBagEndPlace || _loc5_ >= this.BeadBagStartPlace && _loc5_ <= this.BeadBagEndPlace)
            {
               _loc6_ = this._beadBag.getItemAt(_loc5_);
               if(_loc6_)
               {
                  this.setCellInfo(_loc5_,_loc6_);
               }
               else
               {
                  this.setCellInfo(_loc5_,null);
               }
            }
         }
         --BeadManager.instance.comineCount;
         _loc4_ = BeadManager.instance.doJudgeLevelUp();
         if(_loc4_)
         {
            this.showLevelUpCartoon();
            TaskManager.instance.checkHighLight();
         }
         this.playExpTipHandler(!_loc4_);
         this.refreshBeadPowerTxt();
         this.updateProgress(this._beadBag.items[this.BeadBagStartPlace]);
         if(BeadManager.instance.comineCount <= 0)
         {
            BeadManager.instance.doWhatHandle = -1;
         }
         this.judgeCombineOnekeyCell();
         ShowTipManager.Instance.removeAllTip();
      }
      
      private function showLevelUpCartoon() : void
      {
         var _loc1_:MovieClipWrapper = null;
         SoundManager.instance.play("173");
         _loc1_ = new MovieClipWrapper(ClassUtils.CreatInstance("asset.beadSystem.levelUpCartoon"),true,true);
         var _loc2_:int = BeadManager.instance.curPlace;
         _loc1_.movie.x = this._beadList[_loc2_].x + this._beadList[_loc2_].width / 2;
         _loc1_.movie.y = this._beadList[_loc2_].y + this._beadList[_loc2_].height / 2;
         addChild(_loc1_.movie);
      }
      
      private function playExpTipHandler(param1:Boolean) : void
      {
         var addExp:int = 0;
         var txt:FilterFrameText = null;
         var isShowExpCartoon:Boolean = param1;
         if(BeadManager.instance.doWhatHandle == 2 && isShowExpCartoon)
         {
            addExp = (this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo).beadExp - this._recordExp;
            if(BeadManager.instance.comineCount <= 0 && addExp > 0)
            {
               var moveCartoonStep1:Function = function(param1:FilterFrameText):void
               {
                  var moveCartoonStep2:Function = null;
                  var txt:FilterFrameText = param1;
                  moveCartoonStep2 = function(param1:FilterFrameText):void
                  {
                     TweenLite.to(param1,0.4,{
                        "y":param1.y - 46,
                        "alpha":0,
                        "onComplete":disposeExpTipTxt,
                        "onCompleteParams":[param1]
                     });
                  };
                  TweenLite.to(txt,0.4,{
                     "y":txt.y,
                     "alpha":1,
                     "onComplete":moveCartoonStep2,
                     "onCompleteParams":[txt]
                  });
               };
               SoundManager.instance.play("174");
               txt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.combineOnekey.expTip");
               txt.text = LanguageMgr.GetTranslation("beadSystem.bead.combineOneKey.expTip",addExp);
               txt.x = this._beadList[this.BeadBagStartPlace].x + this._beadList[this.BeadBagStartPlace].width / 2 - txt.width / 2;
               txt.y = this._beadList[this.BeadBagStartPlace].y + this._beadList[this.BeadBagStartPlace].height - 20;
               addChild(txt);
               txt.alpha = 0;
               TweenLite.to(txt,0.4,{
                  "y":txt.y - this._beadList[this.BeadBagStartPlace].height / 2,
                  "alpha":1,
                  "onComplete":moveCartoonStep1,
                  "onCompleteParams":[txt]
               });
            }
         }
         else if(this._beadBag.items[this.BeadBagStartPlace])
         {
            this._recordExp = (this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo).beadExp;
         }
      }
      
      private function disposeExpTipTxt(param1:FilterFrameText) : void
      {
         if(param1 && param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function judgeCombineOnekeyCell() : void
      {
         if(this._beadBag.items[this.BeadBagStartPlace])
         {
            this.hideCombineOnekeyCellLight();
            this.showSplitSellBtn();
         }
         else
         {
            this.hideSplitSellBtn();
         }
      }
      
      private function updateProgress(param1:InventoryItemInfo) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc2_:Object = BeadManager.instance.list;
         if(!_loc2_)
         {
            return;
         }
         this._progressBar.visible = Boolean(param1) ? Boolean(true) : Boolean(false);
         if(!param1 || param1.beadLevel == 30)
         {
            _loc3_ = "100";
            this._progressBar.progress = 1;
         }
         else
         {
            _loc4_ = param1.beadLevel == 30 ? int(29) : int(param1.beadLevel);
            _loc5_ = BeadManager.instance.calExpLimit(param1 as InventoryItemInfo);
            this._progressBar.progress = _loc5_[0] / _loc5_[1];
            _loc3_ = String(this._progressBar.progress * 100);
            _loc6_ = _loc3_.split(".");
            if(_loc6_.length != 1)
            {
               _loc3_ = _loc6_[0] + "." + String(_loc6_[1]).substr(0,2);
            }
         }
         this._progressBar.text = _loc3_ + "%";
      }
      
      private function showSplitSellBtn() : void
      {
         if(this._sellSmallBg == null)
         {
            this._sellSmallBg = ComponentFactory.Instance.creatBitmap("asset.beadSystem.splitSellBg");
            addChild(this._sellSmallBg);
            this._sellSmallBg.height = 33;
            this._sellSmallBg.visible = false;
         }
         var _loc1_:InventoryItemInfo = this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo;
         if(_loc1_.beadExp > 0)
         {
            if(this._splitBtn)
            {
               this._splitBtn.visible = true;
            }
            else
            {
               this._splitBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.combineOneKey.splitBtn");
               this._splitBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.split");
               this._splitBtn.addEventListener(MouseEvent.CLICK,this.splitBeadHandler);
               addChild(this._splitBtn);
            }
         }
         else if(this._splitBtn)
         {
            this._splitBtn.visible = false;
         }
         if(this._splitBtn && this._splitBtn.visible)
         {
            this._sellSmallBg.visible = true;
            this._sellSmallBg.y = this._splitBtn.y - 5;
         }
         else
         {
            this._sellSmallBg.visible = false;
         }
      }
      
      private function splitBeadHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("beadSystem.bead.combineOnekey.splitBead.moneyTip",BeadManager.instance.beadConfig.GemSplit),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
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
            if(PlayerManager.Instance.Self.Money + PlayerManager.Instance.Self.DDTMoney < BeadManager.instance.beadConfig.GemSplit)
            {
               LeavePageManager.showFillFrame();
               return;
            }
            SocketManager.Instance.out.sendBeadSplit();
         }
      }
      
      private function doSplitBeadHandler(param1:Event) : void
      {
         var _loc2_:BeadCombineConfirmFrame = param1.currentTarget as BeadCombineConfirmFrame;
         _loc2_.removeEventListener(BeadManager.BEAD_COMBINE_CONFIRM_RETURN_EVENT,this.doSplitBeadHandler);
         if(_loc2_.isYes)
         {
            SocketManager.Instance.out.sendBeadSplit();
         }
      }
      
      private function sellBeadHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if((this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo).beadExp > 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.combineOnekey.sellBead.expTip"));
            return;
         }
         var _loc2_:InventoryItemInfo = this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo;
         var _loc3_:int = BeadManager.instance.list[_loc2_.Property2][_loc2_.beadLevel.toString()].SellScore;
         var _loc4_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("beadSystem.bead.combineConfirm.tip5",BeadManager.instance.getBeadColorName(_loc2_,true,true),_loc3_),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND);
         _loc4_.addEventListener(FrameEvent.RESPONSE,this.onStack3,false,0,true);
      }
      
      private function onStack3(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.target as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.onStack3);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            SocketManager.Instance.out.sendBeadSell();
         }
      }
      
      private function doSellBeadHandler(param1:Event) : void
      {
         var _loc2_:BeadCombineConfirmFrame = param1.currentTarget as BeadCombineConfirmFrame;
         _loc2_.removeEventListener(BeadManager.BEAD_COMBINE_CONFIRM_RETURN_EVENT,this.doSellBeadHandler);
         if(_loc2_.isYes)
         {
            SocketManager.Instance.out.sendBeadSell();
         }
      }
      
      private function hideSplitSellBtn() : void
      {
         if(this._splitBtn)
         {
            this._splitBtn.visible = false;
         }
         if(this._sellSmallBg)
         {
            this._sellSmallBg.visible = false;
         }
      }
      
      public function showCombineOnekeyCellLight() : void
      {
         this._combineOnekeyCellLight.visible = true;
         this._combineOnekeyCellLight.gotoAndPlay(1);
      }
      
      public function hideCombineOnekeyCellLight() : void
      {
         this._combineOnekeyCellLight.visible = false;
         this._combineOnekeyCellLight.gotoAndStop(1);
      }
      
      public function getBeadBagBeadCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = this.BeadBagStartPlace + 1;
         while(_loc2_ <= this.BeadBagEndPlace)
         {
            if(this._beadBag.items[_loc2_])
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getBeadBagLockCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = this.BeadBagStartPlace + 1;
         while(_loc2_ <= this.BeadBagEndPlace)
         {
            if(this._beadBag.items[_loc2_] is InventoryItemInfo)
            {
               if(this._beadBag.items[_loc2_].beadIsLock == 1)
               {
                  _loc1_++;
               }
               else if(this._beadBag.items[_loc2_].beadLevel >= 30)
               {
                  _loc1_++;
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function refreshBeadPowerTxt() : void
      {
         var _loc9_:InventoryItemInfo = null;
         var _loc1_:DictionaryData = this._beadBag.items;
         var _loc2_:int = 0;
         var _loc3_:String = "";
         var _loc4_:String = "    ";
         var _loc5_:String = "   ";
         var _loc6_:String = "  ";
         var _loc7_:Object = BeadManager.instance.list;
         var _loc8_:int = 0;
         while(_loc8_ <= this.EquipBagEndPlace)
         {
            if(_loc1_[_loc8_])
            {
               _loc9_ = _loc1_[_loc8_] as InventoryItemInfo;
               if(_loc9_.beadLevel == 30)
               {
                  _loc2_ += int(_loc7_[_loc9_.Property2][30].Exp);
               }
               else
               {
                  _loc2_ += _loc9_.beadExp;
               }
               _loc3_ += LanguageMgr.GetTranslation("beadSystem.bead.name.color.html",BeadManager.instance.getBeadNameColor(_loc9_),LanguageMgr.GetTranslation("beadSystem.bead.nameLevel",_loc9_.Name,_loc9_.beadLevel,""));
               if(_loc9_.Name.substr(0,1) == "S" || _loc9_.Name.substr(0,1) == "s")
               {
                  if(_loc9_.beadLevel >= 10)
                  {
                     _loc3_ += _loc6_;
                  }
                  else
                  {
                     _loc3_ += _loc5_;
                  }
               }
               else if(_loc9_.beadLevel >= 10)
               {
                  _loc3_ += _loc5_;
               }
               else
               {
                  _loc3_ += _loc4_;
               }
               _loc3_ += BeadManager.instance.getDescriptionStr(_loc9_) + "\n";
            }
            _loc8_++;
         }
         this._beadPowerTxt.text = int(_loc2_ / 10).toString();
         this._beadPowerTxt.tipData = [LanguageMgr.GetTranslation("beadSystem.bead.beadPower.titleTip",this._beadPowerTxt.text),_loc3_];
      }
      
      public function setCellInfo(param1:int, param2:InventoryItemInfo) : void
      {
         this._beadList[String(param1)].info = param2;
         if(SavePointManager.Instance.isInSavePoint(71))
         {
            if(!BeadManager.instance.guildeStepI)
            {
               if(param1 == 12 && param2)
               {
                  BeadManager.instance.guildeStepI = true;
                  NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD,0,"trainer.beadClick1","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               }
            }
            else if(param1 == 0 && param2)
            {
               NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
               BeadManager.instance.guildeStepI = false;
               SavePointManager.Instance.setSavePoint(71);
            }
         }
      }
      
      private function startBeadDrag(param1:InteractiveEvent) : void
      {
         if(this._isLock)
         {
            return;
         }
         var _loc2_:BeadCell = param1.currentTarget as BeadCell;
         if(!_loc2_.locked && _loc2_.info)
         {
            SoundManager.instance.play("008");
            _loc2_.dragStart();
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
            if(SavePointManager.Instance.isInSavePoint(71))
            {
               if(!this._beadList[12].info)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD,180,"trainer.beadClick4","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               }
               else if(!this._beadList[0].info)
               {
                  NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD,-90,"trainer.beadClick3","","",LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
               }
            }
         }
      }
      
      private function removeEvent() : void
      {
         this._beadBag.removeEventListener(BagEvent.UPDATE,this.updateBeadCell);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__lockChange);
      }
      
      public function dispose() : void
      {
         var _loc1_:BeadCell = null;
         this.removeEvent();
         if(this._combineOnekeyCellLight)
         {
            this._combineOnekeyCellLight.gotoAndStop(1);
         }
         ObjectUtils.disposeObject(this._combineOnekeyCellLight);
         this._combineOnekeyCellLight = null;
         for each(_loc1_ in this._beadList)
         {
            _loc1_.removeEventListener(InteractiveEvent.CLICK,this.startBeadDrag);
            _loc1_.removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(_loc1_);
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         this._beadList = null;
         ObjectUtils.disposeObject(this._beadPowerTxt);
         this._beadPowerTxt = null;
         ObjectUtils.disposeObject(this._progressBar);
         this._progressBar = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get isLock() : Boolean
      {
         return this._isLock;
      }
      
      public function set isLock(param1:Boolean) : void
      {
         this._isLock = param1;
      }
   }
}
