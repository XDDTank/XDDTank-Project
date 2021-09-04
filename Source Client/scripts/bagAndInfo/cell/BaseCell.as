package bagAndInfo.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import ddt.interfaces.ICell;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   [Event(name="change",type="flash.events.Event")]
   public class BaseCell extends Sprite implements ICell, ITipedDisplay, Disposeable
   {
       
      
      protected var _bg:DisplayObject;
      
      protected var _contentHeight:Number;
      
      protected var _contentWidth:Number;
      
      protected var _info:ItemTemplateInfo;
      
      protected var _loadingasset:MovieClip;
      
      protected var _pic:CellContentCreator;
      
      protected var _tbxCount:FilterFrameText;
      
      protected var _isShowCount:Boolean = false;
      
      protected var _picPos:Point;
      
      protected var _showLoading:Boolean;
      
      protected var _showTip:Boolean;
      
      protected var _smallPic:Sprite;
      
      protected var _tipData:Object;
      
      protected var _tipDirection:String;
      
      protected var _tipGapH:int;
      
      protected var _tipGapV:int;
      
      protected var _tipStyle:String;
      
      protected var _allowDrag:Boolean;
      
      private var _overBg:DisplayObject;
      
      private var _locked:Boolean;
      
      public function BaseCell(param1:DisplayObject, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Boolean = true)
      {
         super();
         this._bg = param1;
         this._showLoading = param3;
         this._showTip = param4;
         this.init();
         this.initTip();
         this.initEvent();
         this.info = param2;
      }
      
      public function set isShowCount(param1:Boolean) : void
      {
         this._isShowCount = param1;
      }
      
      public function get isShowCount() : Boolean
      {
         return this._isShowCount;
      }
      
      public function get picPos() : Point
      {
         return this._picPos;
      }
      
      public function set picPos(param1:Point) : void
      {
         this._picPos = param1;
      }
      
      public function set overBg(param1:DisplayObject) : void
      {
         ObjectUtils.disposeObject(this._overBg);
         this._overBg = param1;
         if(this._overBg)
         {
            this._overBg.visible = false;
            addChildAt(this._overBg,1);
         }
      }
      
      public function get overBg() : DisplayObject
      {
         return this._overBg;
      }
      
      public function set PicPos(param1:Point) : void
      {
         this._picPos = param1;
         this.updateSize(this._pic);
      }
      
      public function get allowDrag() : Boolean
      {
         return this._allowDrag;
      }
      
      public function set allowDrag(param1:Boolean) : void
      {
         this._allowDrag = param1;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._tbxCount);
         this._tbxCount = null;
         this.clearLoading();
         this.clearCreatingContent();
         this._info = null;
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
      }
      
      public function dragStart() : void
      {
         if(this._info && !this.locked && stage && this._allowDrag)
         {
            if(DragManager.startDrag(this,this._info,this.createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE))
            {
               this.locked = true;
            }
         }
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         if(param1.action == DragEffect.NONE)
         {
            this.locked = false;
         }
      }
      
      public function get editLayer() : int
      {
         return this._pic.editLayer;
      }
      
      public function getContent() : Sprite
      {
         return this._pic;
      }
      
      public function getSmallContent() : Sprite
      {
         this._pic.width = this._pic.height = 40;
         return this._pic;
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function set grayFilters(param1:Boolean) : void
      {
         if(param1)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
      }
      
      override public function get height() : Number
      {
         return this._bg.height + this._bg.y * 2;
      }
      
      public function get info() : ItemTemplateInfo
      {
         if(this._info == null)
         {
            return null;
         }
         return this._info;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         if(this._info == param1 && !this._info)
         {
            return;
         }
         if(this._info)
         {
            ShowTipManager.Instance.removeTip(this);
            this.clearCreatingContent();
            this.clearLoading();
            this._tipData = null;
            this.locked = false;
         }
         this._info = param1;
         this.creatPic();
         this.updateCount();
         if(this._info)
         {
            if(this._showTip)
            {
               ShowTipManager.Instance.addTip(this);
            }
            if(this._showLoading)
            {
               this.createLoading();
            }
            if(this._info.Property1 == "31")
            {
               if(this._info.Property2 == "0")
               {
                  this.tipStyle = "bead.view.ExpBeadTip";
               }
               else
               {
                  this.tipStyle = "beadSystem.beadTipPanel";
               }
               this.tipData = this._info;
            }
            else if(this._info.CategoryID == 40)
            {
               this.tipStyle = "core.EquipTipPanel";
               this.tipData = this._info;
            }
            else
            {
               this.tipStyle = "core.GoodsTip";
               this._tipData = new GoodTipInfo();
               GoodTipInfo(this._tipData).itemInfo = this.info;
            }
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function creatPic() : void
      {
         ObjectUtils.disposeObject(this._pic);
         this._pic = null;
         if(this._info)
         {
            this._pic = new CellContentCreator();
            this._pic.info = this._info;
            this._pic.loadSync(this.createContentComplete);
            addChild(this._pic);
         }
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         if(this._locked == param1)
         {
            return;
         }
         this._locked = param1;
         this.updateLockState();
         if(this._info is InventoryItemInfo)
         {
            this._info["lock"] = this._locked;
         }
         dispatchEvent(new CellEvent(CellEvent.LOCK_CHANGED));
      }
      
      public function setColor(param1:*) : Boolean
      {
         return this._pic.setColor(param1);
      }
      
      public function setContentSize(param1:Number, param2:Number) : void
      {
         this._contentWidth = param1;
         this._contentHeight = param2;
         this.updateSize(this._pic);
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirection;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirection = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      protected function clearCreatingContent() : void
      {
         if(this._pic == null)
         {
            return;
         }
         if(this._pic.parent)
         {
            this._pic.parent.removeChild(this._pic);
         }
         this._pic.clearLoader();
         this._pic.dispose();
         this._pic = null;
      }
      
      protected function createChildren() : void
      {
         this._contentWidth = this._bg.width - 2;
         this._contentHeight = this._bg.height - 2;
         addChildAt(this._bg,0);
         this._tbxCount = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
         this._tbxCount.mouseEnabled = false;
         addChild(this._tbxCount);
         this._pic = new CellContentCreator();
      }
      
      protected function createContentComplete() : void
      {
         this.clearLoading();
         this.updateSize(this._pic);
      }
      
      protected function createDragImg() : DisplayObject
      {
         var _loc1_:Bitmap = null;
         var _loc2_:EquipmentTemplateInfo = null;
         var _loc3_:ScaleFrameImage = null;
         if(this._pic && this._pic.width > 0 && this._pic.height > 0)
         {
            _loc1_ = new Bitmap(new BitmapData(this._pic.width / this._pic.scaleX,this._pic.height / this._pic.scaleY,true,0));
            if(this._info)
            {
               if(this._info.Property8 == "0" && this._info.CategoryID == 40)
               {
                  _loc2_ = ItemManager.Instance.getEquipTemplateById(this._info.TemplateID);
                  if(_loc2_)
                  {
                     _loc3_ = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
                     _loc3_.setFrame(this._info.Quality);
                     this._pic.addChildAt(_loc3_,0);
                     _loc1_.bitmapData.draw(this._pic);
                  }
                  else
                  {
                     _loc1_.bitmapData.draw(this._pic);
                  }
               }
               else
               {
                  _loc1_.bitmapData.draw(this._pic);
               }
            }
            else
            {
               _loc1_.bitmapData.draw(this._pic);
            }
            return _loc1_;
         }
         return null;
      }
      
      protected function createLoading() : void
      {
         if(this._loadingasset == null)
         {
            this._loadingasset = ComponentFactory.Instance.creat("bagAndInfo.cell.BaseCellLoadingAsset");
         }
         this.updateSizeII(this._loadingasset);
         PositionUtils.setPos(this._loadingasset,"ddt.core.baseCell.loadingPos");
         addChild(this._loadingasset);
      }
      
      protected function init() : void
      {
         this._allowDrag = true;
         if(this._showTip)
         {
            ShowTipManager.Instance.addTip(this);
         }
         this.createChildren();
      }
      
      protected function initTip() : void
      {
         this.tipDirctions = "7,6,2,1,5,4,0,3,6";
         this.tipGapV = 10;
         this.tipGapH = 10;
      }
      
      protected function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
         addEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
      }
      
      protected function onMouseOut(param1:MouseEvent) : void
      {
         if(this._overBg)
         {
            this._overBg.visible = false;
         }
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
         if(this._overBg)
         {
            this._overBg.visible = true;
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         removeEventListener(MouseEvent.ROLL_OUT,this.onMouseOut);
         removeEventListener(MouseEvent.ROLL_OVER,this.onMouseOver);
      }
      
      protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            param1.width = this._contentWidth - 2;
            param1.height = this._contentHeight - 2;
            if(this._picPos != null)
            {
               param1.x = this._picPos.x;
            }
            else
            {
               param1.x = Math.abs(param1.width - this._contentWidth) / 2;
            }
            if(this._picPos != null)
            {
               param1.y = this._picPos.y;
            }
            else
            {
               param1.y = Math.abs(param1.height - this._contentHeight) / 2;
            }
         }
      }
      
      protected function clearLoading() : void
      {
         if(this._loadingasset)
         {
            this._loadingasset.stop();
         }
         ObjectUtils.disposeObject(this._loadingasset);
         this._loadingasset = null;
      }
      
      private function updateLockState() : void
      {
         if(this._locked)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return this._info as InventoryItemInfo;
      }
      
      private function updateCount() : void
      {
         if(this._tbxCount)
         {
            if(this._info && this.itemInfo && this.itemInfo.Count > 1 && this.isShowCount)
            {
               this._tbxCount.text = String(this.itemInfo.Count);
               this._tbxCount.visible = true;
               addChild(this._tbxCount);
            }
            else
            {
               this._tbxCount.visible = false;
            }
         }
      }
      
      protected function updateSizeII(param1:Sprite) : void
      {
      }
   }
}
