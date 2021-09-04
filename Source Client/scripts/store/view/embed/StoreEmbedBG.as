package store.view.embed
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import road7th.comm.PackageIn;
   import store.HelpFrame;
   import store.IStoreViewBG;
   import store.events.EmbedEvent;
   import store.view.storeBag.StoreBagCell;
   
   public class StoreEmbedBG extends Sprite implements IStoreViewBG, IDragable, IAcceptDrag
   {
      
      public static const MAX_HOLE:int = 4;
       
      
      private var _removeBtn:BaseButton;
      
      private var _embedTextTip:FilterFrameText;
      
      private var _embedEquipCell:EmbedItemCell;
      
      private var _embedHoleCount:int;
      
      private var _embedStoneList:Vector.<EmbedStoneCell>;
      
      private var _lastEmbedList:Vector.<EmbedStoneCell>;
      
      private var _hbox:HBox;
      
      private var _lastHbox:HBox;
      
      private var _hboxContainer:Sprite;
      
      private var _hboxMask:Sprite;
      
      private var _embedOpenPanel:EmbedOpenPanel;
      
      private var _equipBgMC:MovieClip;
      
      private var _embedSuccessMc:MovieClip;
      
      private var _hboxPos:Point;
      
      private var _alert:BaseAlerFrame;
      
      private var _lastItemID:int;
      
      private var _info:InventoryItemInfo;
      
      private var _alertCall:Function;
      
      private var _removeGold:Array;
      
      private var _needGold:int;
      
      private var _tipBg:Bitmap;
      
      public function StoreEmbedBG()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._removeBtn = ComponentFactory.Instance.creat("ddtstore.embed.embedBg.removeBtn");
         addChild(this._removeBtn);
         this._equipBgMC = ComponentFactory.Instance.creat("ddtstore.embedBg.equipBgMC");
         this._equipBgMC.stop();
         this._equipBgMC.visible = false;
         addChild(this._equipBgMC);
         this._embedSuccessMc = ComponentFactory.Instance.creat("ddtstore.embedBg.embedSuccessMc");
         this._embedSuccessMc.stop();
         this._embedSuccessMc.visible = false;
         addChild(this._embedSuccessMc);
         this._embedTextTip = ComponentFactory.Instance.creat("ddtstore.embed.embedBg.embedTextTip");
         this._embedTextTip.text = LanguageMgr.GetTranslation("ddt.store.embedBG.embedTipText");
         addChild(this._embedTextTip);
         this._embedEquipCell = ComponentFactory.Instance.creat("ddtstore.embed.embedBg.embedCell",[0]);
         addChild(this._embedEquipCell);
         this._embedOpenPanel = new EmbedOpenPanel();
         this._embedOpenPanel.visible = false;
         addChild(this._embedOpenPanel);
         this._hboxContainer = new Sprite();
         this._hboxMask = new Sprite();
         var _loc1_:Rectangle = ComponentFactory.Instance.creat("ddtstore.embedBg.maskRect");
         this._hboxMask.graphics.beginFill(255);
         this._hboxMask.graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
         this._hboxMask.graphics.endFill();
         this._hboxContainer.cacheAsBitmap = true;
         this._hboxContainer.mask = this._hboxMask;
         addChild(this._hboxMask);
         addChild(this._hboxContainer);
         this._hboxPos = ComponentFactory.Instance.creat("ddtstore.embedBg.hboxPos");
         this._removeGold = ServerConfigManager.instance.findInfoByName(ServerConfigManager.REMOVAL_RUNE_NEED_GOLD).Value.split("|");
         this._tipBg = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EmbedBG.embedTipBM");
         this._tipBg.visible = true;
         addChild(this._tipBg);
      }
      
      private function initEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOLE_EQUIP,this.__openHoleResponse);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MOSAIC_EQUIP,this.__embedResponse);
         this._removeBtn.addEventListener(MouseEvent.CLICK,this.__removeBtnClick);
         this._embedEquipCell.addEventListener(EmbedEvent.MOVE,this.__moveEquip);
      }
      
      private function removeEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOLE_EQUIP,this.__openHoleResponse);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MOSAIC_EQUIP,this.__embedResponse);
         this._removeBtn.removeEventListener(MouseEvent.CLICK,this.__removeBtnClick);
         this._embedSuccessMc.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._embedEquipCell.removeEventListener(EmbedEvent.MOVE,this.__moveEquip);
         if(this._alert)
         {
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__bindAlertResponse);
         }
      }
      
      protected function __removeBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         Mouse.hide();
         DragManager.startDrag(this,null,ComponentFactory.Instance.creat("asset.ddtstore.EmbedBG.removeIcon"),StageReferance.stage.mouseX,StageReferance.stage.mouseY,DragEffect.MOVE,false);
      }
      
      protected function __moveEquip(param1:EmbedEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._tipBg.visible = false;
         var _loc2_:InventoryItemInfo = param1.data;
         this.sendMoveItem(_loc2_);
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         Mouse.show();
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      protected function __openHoleResponse(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Boolean = _loc2_.readBoolean();
         if(_loc4_ && this._embedStoneList)
         {
            this._embedStoneList[_loc3_].shineSuccessMC();
         }
      }
      
      protected function __embedResponse(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:Boolean = _loc2_.readBoolean();
         if(_loc5_)
         {
            switch(_loc3_)
            {
               case 1:
                  this.showEmbedMovie();
                  SoundManager.instance.pauseMusic();
                  SoundManager.instance.play("063",false,false);
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.successmsg"));
                  break;
               case 2:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.failmsg"));
                  break;
               case 3:
                  this.showEmbedMovie();
                  SoundManager.instance.pauseMusic();
                  SoundManager.instance.play("063",false,false);
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.changemsg"));
            }
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.errormsg"));
         }
      }
      
      private function showEmbedMovie() : void
      {
         this._equipBgMC.stop();
         this._equipBgMC.visible = false;
         this._embedSuccessMc.visible = true;
         this._embedSuccessMc.gotoAndPlay(1);
         this._embedSuccessMc.addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      protected function __enterFrame(param1:Event) : void
      {
         if(this._embedSuccessMc.currentFrame == 20)
         {
            this._equipBgMC.gotoAndPlay(1);
            this._equipBgMC.visible = false;
         }
         else if(this._embedSuccessMc.currentFrame >= this._embedSuccessMc.totalFrames)
         {
            this._embedSuccessMc.stop();
            this._embedSuccessMc.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._embedSuccessMc.visible = false;
            this._equipBgMC.visible = true;
         }
      }
      
      private function createEmbedList(param1:int) : void
      {
         var _loc2_:EmbedStoneCell = null;
         this.removeOldCells();
         if(this._hbox)
         {
            TweenMax.killTweensOf(this._hbox);
            this._hbox.x = this._hboxPos.x;
            this._hbox.y = this._hboxPos.y;
            this._lastHbox = this._hbox;
            this._lastEmbedList = this._embedStoneList;
            this._lastHbox.mouseEnabled = false;
            this._lastHbox.mouseChildren = false;
            TweenMax.to(this._lastHbox,0.5,{
               "x":-this._lastHbox.width,
               "ease":Back.easeInOut,
               "onComplete":this.removeOldCells
            });
         }
         this._hbox = ComponentFactory.Instance.creat("asset.ddtstore.EmbedBG.embedHBox");
         this._hboxContainer.addChild(this._hbox);
         this._embedStoneList = new Vector.<EmbedStoneCell>();
         this._hbox.beginChanges();
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_ = new EmbedStoneCell(_loc3_);
            _loc2_.addEventListener(EmbedEvent.EMBED,this.__onEmbed);
            this._embedStoneList.push(_loc2_);
            this._hbox.addChild(_loc2_);
            _loc3_++;
         }
         this._hbox.commitChanges();
         TweenMax.to(this._hbox,0.5,{
            "x":this._hboxPos.x - this._hbox.width / 2,
            "y":this._hboxPos.y,
            "ease":Back.easeInOut,
            "onComplete":this.removeOldCells
         });
      }
      
      private function removeOldCells() : void
      {
         var _loc1_:EmbedStoneCell = null;
         while(this._lastEmbedList && this._lastEmbedList.length > 0)
         {
            _loc1_ = this._lastEmbedList.shift();
            _loc1_.removeEventListener(EmbedEvent.EMBED,this.__onEmbed);
            _loc1_.dispose();
         }
         this._lastEmbedList = null;
         TweenMax.killTweensOf(this._lastHbox);
         ObjectUtils.disposeObject(this._lastHbox);
         this._lastHbox = null;
      }
      
      protected function __onEmbed(param1:EmbedEvent) : void
      {
         var cell:EmbedStoneCell = null;
         var equipInfo:EquipmentTemplateInfo = null;
         var eInfo:EquipmentTemplateInfo = null;
         var result:int = 0;
         var event:EmbedEvent = param1;
         SoundManager.instance.play("008");
         if(BaglockedManager.Instance.isBagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         this._tipBg.visible = false;
         cell = event.target as EmbedStoneCell;
         if(this._alert)
         {
            this._alertCall = null;
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__bindAlertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert = null;
         }
         this._needGold = this._removeGold[cell.index];
         if(event.data)
         {
            equipInfo = ItemManager.Instance.getEquipTemplateById(event.data.TemplateID);
            if(equipInfo && equipInfo.TemplateType == 12)
            {
               if(cell.holeID < 0)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.noOpenmsg"));
                  return;
               }
               eInfo = ItemManager.Instance.getEquipTemplateById(event.data.TemplateID);
               result = this.checkCanEmbed(cell.index,eInfo);
               switch(result)
               {
                  case 1:
                     if(cell.info)
                     {
                        this._alertCall = function():void
                        {
                           SocketManager.Instance.out.sendItemEmbed(3,cell.index,event.data.Place);
                        };
                        if(this._info.IsBinds && !event.data.IsBinds || !this._info.IsBinds && event.data.IsBinds)
                        {
                           this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.bindmsg"),LanguageMgr.GetTranslation("yes"),LanguageMgr.GetTranslation("no"),false,true);
                           this._alert.addEventListener(FrameEvent.RESPONSE,this.__bindAlertResponse);
                        }
                        else
                        {
                           this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.msg",this._needGold),LanguageMgr.GetTranslation("yes"),LanguageMgr.GetTranslation("no"),false,true);
                           this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
                        }
                     }
                     else
                     {
                        SocketManager.Instance.out.sendItemEmbed(1,cell.index,event.data.Place);
                     }
                     break;
                  case 0:
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.samemsg"));
                     break;
                  case -1:
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.errormsg"));
               }
            }
            else
            {
               this.sendMoveItem(event.data);
            }
         }
         else if(cell.info)
         {
            this._alertCall = function():void
            {
               SocketManager.Instance.out.sendItemEmbed(2,cell.index,0);
            };
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.store.embedBG.removeStone.msg",this._needGold),LanguageMgr.GetTranslation("yes"),LanguageMgr.GetTranslation("no"),false,true);
            this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         }
      }
      
      protected function __bindAlertResponse(param1:FrameEvent) : void
      {
         this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         this._alert.removeEventListener(FrameEvent.RESPONSE,this.__bindAlertResponse);
         ObjectUtils.disposeObject(this._alert);
         this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.msg",this._needGold),LanguageMgr.GetTranslation("yes"),LanguageMgr.GetTranslation("no"),false,true);
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__alertResponse);
      }
      
      private function __alertResponse(param1:FrameEvent) : void
      {
         var _loc2_:QuickBuyFrame = null;
         this._alert.removeEventListener(FrameEvent.RESPONSE,this.__alertResponse);
         this._alert.removeEventListener(FrameEvent.RESPONSE,this.__bindAlertResponse);
         ObjectUtils.disposeObject(this._alert);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(PlayerManager.Instance.Self.Gold < this._needGold)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.lessGoldmsg"));
                  _loc2_ = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                  _loc2_.itemID = EquipType.GOLD_BOX;
                  _loc2_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                  LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
                  break;
               }
               if(this._alertCall != null)
               {
                  this._alertCall();
                  break;
               }
               break;
         }
         this._alertCall = null;
      }
      
      private function findEmbedIndex(param1:InventoryItemInfo) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
         if(!_loc2_)
         {
            throw new Error("装备列表找不到该符文 id:" + param1.TemplateID);
         }
         if(!this._info)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.noEquipmsg"));
            return -1;
         }
         if(_loc2_.TemplateType != EquipType.EMBED_TYPE)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.errorTypemsg"));
            return -1;
         }
         _loc3_ = 0;
         for(; _loc3_ < MAX_HOLE; _loc3_++)
         {
            if(this._info["Hole" + (_loc3_ + 1)] != 1)
            {
               continue;
            }
            _loc4_ = this.checkCanEmbed(_loc3_,_loc2_);
            switch(_loc4_)
            {
               case 1:
                  return _loc3_;
               case 0:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.samemsg"));
                  return -1;
               case -1:
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.errormsg"));
                  return -1;
            }
         }
         if(_loc3_ < EquipType.getEmbedHoleCount(this._info))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.openHolemsg"));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.fullmsg"));
         }
         return -1;
      }
      
      private function checkCanEmbed(param1:int, param2:EquipmentTemplateInfo) : int
      {
         var _loc3_:EquipmentTemplateInfo = null;
         var _loc4_:int = 0;
         if(!this._info)
         {
            return -1;
         }
         if(this._info["Hole" + (param1 + 1)] > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < MAX_HOLE)
            {
               if(_loc4_ != param1)
               {
                  _loc3_ = ItemManager.Instance.getEquipTemplateById(this._info["Hole" + (_loc4_ + 1)]);
                  if(_loc3_)
                  {
                     if(_loc3_.MainProperty1ID == param2.MainProperty1ID && _loc3_.MainProperty2ID == param2.MainProperty2ID || _loc3_.MainProperty1ID == param2.MainProperty2ID && _loc3_.MainProperty2ID == param2.MainProperty1ID)
                     {
                        return 0;
                     }
                  }
               }
               _loc4_++;
            }
            return 1;
         }
         return -1;
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._info;
      }
      
      public function set info(param1:InventoryItemInfo) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this._info = param1;
         var _loc2_:Boolean = this._info && this._lastItemID != this._info.ItemID;
         this._embedEquipCell.info = this._info;
         if(this._info)
         {
            this._tipBg.visible = false;
            this._lastItemID = this._info.ItemID;
            if(_loc2_)
            {
               this._embedHoleCount = EquipType.getEmbedHoleCount(this._info);
               this.createEmbedList(this._embedHoleCount);
            }
            _loc3_ = 0;
            while(_loc3_ < this._embedHoleCount)
            {
               this._embedStoneList[_loc3_].holeID = this._info["Hole" + (_loc3_ + 1)];
               _loc3_++;
            }
            _loc4_ = this.getFisrtUnOpenHole(this._info,this._embedHoleCount);
            if(_loc4_ < 0)
            {
               this._embedOpenPanel.visible = false;
            }
            else
            {
               this._embedOpenPanel.x = this._embedStoneList[_loc4_].x + this._hboxPos.x - this._hbox.width / 2 - 8 + 20;
               this._embedOpenPanel.y = this._hboxPos.y + this._hbox.height + 7;
               this._embedOpenPanel.index = _loc4_;
               this._embedOpenPanel.info = this._info;
               this._embedOpenPanel.visible = true;
            }
            this._hbox.visible = true;
            this._equipBgMC.gotoAndPlay(1);
            this._equipBgMC.visible = true;
         }
         else
         {
            if(this._hbox)
            {
               this._hbox.visible = false;
            }
            this._tipBg.visible = true;
            this._equipBgMC.stop();
            this._equipBgMC.visible = false;
            this._embedOpenPanel.visible = false;
         }
      }
      
      public function setCell(param1:BagCell) : void
      {
         var _loc3_:EquipmentTemplateInfo = null;
         var _loc4_:int = 0;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(!param1)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.info as InventoryItemInfo;
         if(!_loc2_)
         {
            return;
         }
         this._tipBg.visible = false;
         if(_loc2_.CategoryID == EquipType.EQUIP)
         {
            _loc3_ = ItemManager.Instance.getEquipTemplateById(_loc2_.TemplateID);
            if(_loc3_.TemplateType == 12)
            {
               if(!this._info)
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.noEquipmsg"));
                  return;
               }
               _loc4_ = this.findEmbedIndex(_loc2_);
               if(_loc4_ > -1)
               {
                  SocketManager.Instance.out.sendItemEmbed(1,_loc4_,_loc2_.Place);
               }
               else
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.fullmsg"));
               }
            }
            else
            {
               this.sendMoveItem(_loc2_);
            }
         }
      }
      
      private function sendMoveItem(param1:InventoryItemInfo) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         if(!param1)
         {
            return;
         }
         if(param1.CategoryID == EquipType.EQUIP)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(param1.TemplateID);
            if(_loc2_.TemplateType != 12)
            {
               if(param1)
               {
                  if(param1.getRemainDate() < 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                  }
                  if(EquipType.getEmbedHoleCount(param1) == 0)
                  {
                     MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.cannotEmbed"));
                  }
                  else if(param1.CanEquip)
                  {
                     SocketManager.Instance.out.sendMoveGoods(param1.BagType,param1.Place,BagInfo.STOREBAG,0,1);
                  }
               }
            }
         }
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:StoreBagCell = param1.source as StoreBagCell;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:InventoryItemInfo = _loc2_.info as InventoryItemInfo;
         this.sendMoveItem(_loc3_);
         param1.action = DragEffect.NONE;
         DragManager.acceptDrag(this);
      }
      
      private function getFisrtUnOpenHole(param1:InventoryItemInfo, param2:int) : int
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            if(this._info["Hole" + (_loc3_ + 1)] == -1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function refreshData(param1:Dictionary) : void
      {
         this._embedSuccessMc.stop();
         this._embedSuccessMc.removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         this._embedSuccessMc.visible = false;
         this.info = PlayerManager.Instance.Self.StoreBag.items[0];
      }
      
      public function updateData() : void
      {
      }
      
      public function startShine() : void
      {
         this._embedEquipCell.shinerPos = new Point(2,2);
         this._embedEquipCell.startShine();
      }
      
      public function startEmbedShine() : void
      {
         var _loc1_:EmbedStoneCell = null;
         if(this._embedStoneList)
         {
            for each(_loc1_ in this._embedStoneList)
            {
               if(_loc1_.holeID > 0)
               {
                  _loc1_.startShine();
               }
            }
         }
      }
      
      public function stopShine() : void
      {
         var _loc1_:EmbedStoneCell = null;
         this._embedEquipCell.stopShine();
         for each(_loc1_ in this._embedStoneList)
         {
            _loc1_.stopShine();
         }
      }
      
      public function show() : void
      {
         this.visible = true;
         this.refreshData(null);
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function dispose() : void
      {
         var _loc1_:EmbedStoneCell = null;
         this.removeEvent();
         SoundManager.instance.resumeMusic();
         SoundManager.instance.stop("063");
         SoundManager.instance.stop("064");
         ObjectUtils.disposeObject(this._removeBtn);
         this._removeBtn = null;
         ObjectUtils.disposeObject(this._embedEquipCell);
         this._embedEquipCell = null;
         ObjectUtils.disposeObject(this._embedTextTip);
         this._embedTextTip = null;
         this.removeOldCells();
         while(this._embedStoneList && this._embedStoneList.length > 0)
         {
            _loc1_ = this._embedStoneList.shift();
            _loc1_.removeEventListener(EmbedEvent.EMBED,this.__onEmbed);
            _loc1_.dispose();
         }
         this._embedStoneList = null;
         TweenMax.killTweensOf(this._hbox);
         ObjectUtils.disposeObject(this._hbox);
         this._hbox = null;
         ObjectUtils.disposeObject(this._hboxContainer);
         this._hboxContainer = null;
         ObjectUtils.disposeObject(this._hboxMask);
         this._hboxMask = null;
         ObjectUtils.disposeObject(this._embedOpenPanel);
         this._embedOpenPanel = null;
         ObjectUtils.disposeObject(this._equipBgMC);
         this._equipBgMC = null;
         ObjectUtils.disposeObject(this._embedSuccessMc);
         this._embedSuccessMc = null;
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         this._info = null;
         this._alertCall = null;
         this._removeGold.length = 0;
         this._removeGold = null;
      }
      
      public function openHelp() : void
      {
         var _loc1_:DisplayObject = ComponentFactory.Instance.creat("ddtstore.EmbedHelpPrompt");
         var _loc2_:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
         _loc2_.setView(_loc1_);
         _loc2_.titleText = LanguageMgr.GetTranslation("store.StoreIIEmbedBG.say");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.STAGE_DYANMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}
