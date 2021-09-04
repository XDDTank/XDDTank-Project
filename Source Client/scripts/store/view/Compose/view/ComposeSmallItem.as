package store.view.Compose.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.BagEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import store.data.ComposeItemInfo;
   import store.view.Compose.ComposeController;
   import store.view.Compose.ComposeEvents;
   
   public class ComposeSmallItem extends Sprite implements Disposeable
   {
       
      
      private var _num:int;
      
      private var _parent:int;
      
      private var _topParent:int;
      
      private var _selected:Boolean;
      
      private var _bigItemDic:DictionaryData;
      
      private var _smallItemDic:DictionaryData;
      
      private var _itemTextSelected:FilterFrameText;
      
      private var _itemText:FilterFrameText;
      
      private var _numTextSeletecd:FilterFrameText;
      
      private var _numText:FilterFrameText;
      
      private var _linePic:Bitmap;
      
      private var _mouseOver:Bitmap;
      
      public function ComposeSmallItem(param1:int, param2:int, param3:int)
      {
         super();
         this._num = param1;
         this._parent = param2;
         this._topParent = param3;
         this._bigItemDic = ComposeController.instance.model.composeBigDic;
         this._smallItemDic = ComposeController.instance.model.composeSmallDic;
         this.initView();
         this.initEvent();
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         if(this._selected)
         {
            ComposeController.instance.model.saveSelectedPageSmall(this._topParent,this._num);
         }
         this._itemTextSelected.visible = param1 == true;
         this._itemText.visible = param1 == false;
         this.setCountText();
      }
      
      private function initView() : void
      {
         this._mouseOver = ComponentFactory.Instance.creatBitmap("asset.ddtstore.composeItemsView.small.mouseOver");
         this._mouseOver.visible = false;
         addChild(this._mouseOver);
         this._itemTextSelected = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.smallItem.text");
         this._itemText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.smallItem.text2");
         this._numTextSeletecd = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.smallItem.textNum");
         this._numText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.smallItem.textNum2");
         this._itemTextSelected.text = this._itemText.text = this._smallItemDic[this._bigItemDic[this._topParent]][this._parent][this._num].Name;
         this.setCountText();
         this._itemTextSelected.visible = false;
         this._itemText.visible = true;
         addChild(this._itemText);
         addChild(this._itemTextSelected);
         addChild(this._numText);
         addChild(this._numTextSeletecd);
         this._linePic = ComponentFactory.Instance.creatBitmap("asset.ddtstore.composeItemsView.small.linePic");
         addChild(this._linePic);
      }
      
      private function setCountText() : void
      {
         var _loc1_:int = this.getComposeCount();
         this._numTextSeletecd.visible = _loc1_ != 0 && this._selected;
         this._numText.visible = _loc1_ != 0 && !this._selected;
         this._numTextSeletecd.text = this._numText.text = "(" + _loc1_.toString() + ")";
      }
      
      private function getComposeCount() : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc1_:int = 9999;
         var _loc2_:int = this._smallItemDic[this._bigItemDic[this._topParent]][this._parent][this._num].TemplateID;
         var _loc3_:ComposeItemInfo = ComposeController.instance.model.composeItemInfoDic[_loc2_];
         if(_loc3_ && _loc3_.Material1ID)
         {
            _loc4_ = PlayerManager.Instance.Self.findItemCount(_loc3_.Material1ID);
            _loc5_ = _loc3_.NeedCount1;
            _loc1_ = _loc4_ / _loc5_ > _loc1_ ? int(_loc1_) : int(_loc4_ / _loc5_);
         }
         if(_loc3_ && _loc3_.Material2ID)
         {
            _loc6_ = PlayerManager.Instance.Self.findItemCount(_loc3_.Material2ID);
            _loc7_ = _loc3_.NeedCount2;
            _loc1_ = _loc6_ / _loc7_ > _loc1_ ? int(_loc1_) : int(_loc6_ / _loc7_);
         }
         if(_loc3_ && _loc3_.Material3ID)
         {
            _loc8_ = PlayerManager.Instance.Self.findItemCount(_loc3_.Material3ID);
            _loc9_ = _loc3_.NeedCount3;
            _loc1_ = _loc8_ / _loc9_ > _loc1_ ? int(_loc1_) : int(_loc8_ / _loc9_);
         }
         if(_loc3_ && _loc3_.Material4ID)
         {
            _loc10_ = PlayerManager.Instance.Self.findItemCount(_loc3_.Material4ID);
            _loc11_ = _loc3_.NeedCount4;
            _loc1_ = _loc10_ / _loc11_ > _loc1_ ? int(_loc1_) : int(_loc10_ / _loc11_);
         }
         return _loc1_;
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__clickHandle);
         ComposeController.instance.model.addEventListener(ComposeEvents.CLICK_SMALL_ITEM,this.__selected);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __clickHandle(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         ComposeController.instance.model.currentItem = this._smallItemDic[this._bigItemDic[this._topParent]][this._parent][this._num];
      }
      
      private function __selected(param1:ComposeEvents) : void
      {
         if(ComposeController.instance.model.currentItem)
         {
            this.selected = ComposeController.instance.model.currentItem.TemplateID == this._smallItemDic[this._bigItemDic[this._topParent]][this._parent][this._num].TemplateID;
         }
      }
      
      private function __updateCount(param1:BagEvent) : void
      {
         this.setCountText();
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         this._mouseOver.visible = true;
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         this._mouseOver.visible = false;
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__clickHandle);
         ComposeController.instance.model.removeEventListener(ComposeEvents.CLICK_SMALL_ITEM,this.__selected);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._itemText);
         this._itemText = null;
         ObjectUtils.disposeObject(this._itemTextSelected);
         this._itemTextSelected = null;
         ObjectUtils.disposeObject(this._linePic);
         this._linePic = null;
      }
   }
}
