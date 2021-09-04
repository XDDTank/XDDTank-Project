package store.view.Compose.view
{
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.image.ScaleUpDownImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import road7th.data.DictionaryData;
   import store.view.Compose.ComposeController;
   import store.view.Compose.ComposeEvents;
   import store.view.Compose.ComposeType;
   
   public class ComposeBigItem extends Sprite implements Disposeable
   {
       
      
      private var _num:int;
      
      private var _selected:Boolean;
      
      private var _selectedMiddleNum:int = -1;
      
      private var _bigItemDic:DictionaryData;
      
      private var _middleItemDic:DictionaryData;
      
      private var _smallItemDic:DictionaryData;
      
      private var _bg:ScaleFrameImage;
      
      private var _bgSelected2:ScaleUpDownImage;
      
      private var _icon:Bitmap;
      
      private var _textPic:ScaleFrameImage;
      
      private var _itemVbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _pos2:Point;
      
      private var _enable:Boolean = true;
      
      public function ComposeBigItem(param1:int)
      {
         super();
         this._num = param1;
         this._bigItemDic = ComposeController.instance.model.composeBigDic;
         this._middleItemDic = ComposeController.instance.model.composeMiddelDic;
         this._smallItemDic = ComposeController.instance.model.composeSmallDic;
         this.initView();
         this.initEvent();
      }
      
      private function get selectedMiddleNum() : int
      {
         this._selectedMiddleNum = ComposeController.instance.model.getSeletedPageMiddle(this.num);
         if(this._selectedMiddleNum == -1 && this.num == ComposeType.EQUIP)
         {
            this._selectedMiddleNum = this._middleItemDic[this._bigItemDic[this._num]].length - 1;
         }
         return this._selectedMiddleNum;
      }
      
      public function get num() : int
      {
         return this._num;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this._bg.setFrame(param1 == true ? int(1) : int(2));
         this._textPic.setFrame(param1 == true ? int(1) : int(2));
         if(this._selected)
         {
            this.initFollowView();
         }
         else
         {
            this.removeFollowView();
         }
         this.initBg();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      private function initView() : void
      {
         this._pos2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.composeItemsView.pos2");
         this._bgSelected2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtstore.composeItemsView.big.selected.mid");
         this._bgSelected2.visible = false;
         addChild(this._bgSelected2);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.composeItemsView.big.bg");
         this._bg.setFrame(2);
         this._bg.buttonMode = true;
         addChild(this._bg);
         this._icon = ComponentFactory.Instance.creatBitmap("asset.ddtstore.composeItemsView.big.Icon." + this._bigItemDic[this._num]);
         addChild(this._icon);
         this._textPic = ComponentFactory.Instance.creatComponentByStylename("asset.ddtstore.composeItemsView.big.select.Text." + this._bigItemDic[this._num]);
         this._textPic.setFrame(2);
         this._textPic.buttonMode = true;
         addChild(this._textPic);
      }
      
      private function initFollowView() : void
      {
         var _loc3_:int = 0;
         var _loc4_:ComposeMiddelItem = null;
         var _loc5_:int = 0;
         var _loc6_:ComposeSmallItem = null;
         if(this._scrollPanel)
         {
            this.removeFollowView();
         }
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.bigItem.ScrollPanel");
         this._itemVbox = new VBox();
         var _loc1_:IntPoint = new IntPoint();
         var _loc2_:int = 0;
         if(this._middleItemDic[this._bigItemDic[this._num]])
         {
            _loc3_ = 0;
            while(_loc3_ < this._middleItemDic[this._bigItemDic[this._num]].length)
            {
               _loc4_ = new ComposeMiddelItem(_loc3_,this._num);
               _loc4_.addEventListener(ComposeEvents.CLICK_MIDDLE_ITEM,this.__clickMiddleItem);
               if(this._selected && _loc4_.num == this.selectedMiddleNum)
               {
                  _loc4_.selected = true;
                  _loc2_ = _loc3_;
               }
               else
               {
                  _loc4_.selected = false;
               }
               this._itemVbox.spacing = 4;
               this._itemVbox.addChild(_loc4_);
               _loc3_++;
            }
            this._scrollPanel.setView(this._itemVbox);
         }
         else if(this._smallItemDic.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < this._smallItemDic[this._num][0].length)
            {
               _loc6_ = new ComposeSmallItem(_loc5_,0,this._num);
               addChild(_loc6_);
               _loc5_++;
            }
         }
         if(this._itemVbox.numChildren > 0)
         {
            _loc1_.x = this._itemVbox.getChildAt(_loc2_).x;
            _loc1_.y = this._itemVbox.getChildAt(_loc2_).y;
            this._scrollPanel.invalidateViewport();
            this._scrollPanel.viewPort.viewPosition = _loc1_;
            addChild(this._scrollPanel);
         }
      }
      
      private function __clickMiddleItem(param1:ComposeEvents) : void
      {
         var _loc2_:int = param1.num;
         this._selectedMiddleNum = _loc2_;
         this.initFollowView();
      }
      
      private function initBg() : void
      {
         if(this._selected)
         {
            this._bgSelected2.x = -3;
            this._bgSelected2.y = -2;
            this._bgSelected2.height = this.height - this._bg.height;
            this._bgSelected2.height = this._bgSelected2.height > this._pos2.y ? Number(this._pos2.y + 90) : Number(this._bgSelected2.height + 90);
            this._bgSelected2.visible = true;
         }
         else
         {
            this._bgSelected2.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         this._bg.addEventListener(MouseEvent.CLICK,this.__clickHandle);
         this._textPic.addEventListener(MouseEvent.CLICK,this.__clickHandle);
      }
      
      private function __clickHandle(param1:MouseEvent) : void
      {
         if(!this._enable)
         {
            return;
         }
         SoundManager.instance.playButtonSound();
         dispatchEvent(new ComposeEvents(ComposeEvents.CLICK_BIG_ITEM));
      }
      
      private function removeFollowView() : void
      {
         if(this._itemVbox)
         {
            this._itemVbox.disposeAllChildren();
         }
         if(this._scrollPanel)
         {
            ObjectUtils.disposeObject(this._scrollPanel);
            this._scrollPanel = null;
         }
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
      
      public function set enable(param1:Boolean) : void
      {
         this._enable = param1;
         if(this._enable)
         {
            this.useHandCursor = true;
            this.filters = [];
         }
         else
         {
            this.useHandCursor = false;
            this.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
         }
      }
      
      public function removeEvent() : void
      {
         this._bg.removeEventListener(MouseEvent.CLICK,this.__clickHandle);
         this._textPic.removeEventListener(MouseEvent.CLICK,this.__clickHandle);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.removeFollowView();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._bgSelected2)
         {
            ObjectUtils.disposeObject(this._bgSelected2);
            this._bgSelected2 = null;
         }
         if(this._icon)
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
         }
         if(this._textPic)
         {
            ObjectUtils.disposeObject(this._textPic);
            this._textPic = null;
         }
      }
   }
}
