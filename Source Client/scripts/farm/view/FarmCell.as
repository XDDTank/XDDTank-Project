package farm.view
{
   import bagAndInfo.cell.BaseCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   
   public class FarmCell extends BaseCell
   {
       
      
      private var _bgbmp:ScaleBitmapImage;
      
      private var _manureNum:FilterFrameText;
      
      private var _invInfo:InventoryItemInfo;
      
      private var _continueDrag:Boolean;
      
      private var _contentData:BitmapData;
      
      public function FarmCell()
      {
         buttonMode = true;
         this._bgbmp = ComponentFactory.Instance.creatComponentByStylename("asset.farm.cropIconBg");
         super(this._bgbmp);
         this._bgbmp.buttonMode = true;
         addEventListener(MouseEvent.MOUSE_OVER,this.__overFilter);
         addEventListener(MouseEvent.MOUSE_OUT,this.__outFilter);
      }
      
      protected function __outFilter(param1:MouseEvent) : void
      {
         filters = null;
      }
      
      protected function __overFilter(param1:MouseEvent) : void
      {
         filters = ComponentFactory.Instance.creatFilters("lightFilter");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._manureNum = ComponentFactory.Instance.creatComponentByStylename("farm.seedSelect.cropNum");
      }
      
      override public function get itemInfo() : InventoryItemInfo
      {
         return this._invInfo;
      }
      
      public function set itemInfo(param1:InventoryItemInfo) : void
      {
         super.info = param1;
         this._invInfo = param1;
         if(param1)
         {
            this._manureNum.text = param1.Count.toString();
            addChild(this._manureNum);
         }
      }
      
      override public function dragStart() : void
      {
         if(_info && stage && _allowDrag)
         {
            if(DragManager.startDrag(this,this._invInfo,this.createDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE,false,false,false,false,false,null,0,true))
            {
               Mouse.hide();
               locked = true;
            }
         }
      }
      
      override protected function createContentComplete() : void
      {
         super.createContentComplete();
         if(_pic && _pic.width > 0 && _pic.height > 0)
         {
            this._contentData = new BitmapData(_pic.width / _pic.scaleX,_pic.height / _pic.scaleY,true,0);
            this._contentData.draw(_pic);
         }
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         if(param1.target is FarmFieldBlock)
         {
            this.dragStart();
         }
         if(!DragManager.proxy)
         {
            Mouse.show();
         }
      }
      
      override protected function createDragImg() : DisplayObject
      {
         var _loc1_:Bitmap = null;
         if(_pic && _pic.width > 0 && _pic.height > 0)
         {
            _loc1_ = new Bitmap(this._contentData.clone(),"auto",true);
            _loc1_.width = 35;
            _loc1_.height = 35;
            return _loc1_;
         }
         return null;
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            param1.width = _contentWidth - 20;
            param1.height = _contentHeight - 20;
            if(_picPos != null)
            {
               param1.x = _picPos.x;
            }
            else
            {
               param1.x = Math.abs(param1.width - _contentWidth) / 2;
            }
            if(_picPos != null)
            {
               param1.y = _picPos.y;
            }
            else
            {
               param1.y = Math.abs(param1.height - _contentHeight) / 2;
            }
         }
      }
      
      override protected function updateSizeII(param1:Sprite) : void
      {
         param1.x = 13;
         param1.y = 10;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._bgbmp);
         this._bgbmp = null;
         ObjectUtils.disposeObject(this._manureNum);
         this._manureNum = null;
         ObjectUtils.disposeObject(this._contentData);
         this._contentData = null;
         this._invInfo = null;
      }
   }
}
