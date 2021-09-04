package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.VipConfigInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class SpreeItem extends Sprite implements Disposeable
   {
       
      
      private var _itemBg:Bitmap;
      
      private var _SpreeBg:Bitmap;
      
      private var _itemTxt:FilterFrameText;
      
      private var _itemTip:OneLineTip;
      
      private var _vipInfo:VipConfigInfo;
      
      public function SpreeItem()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._itemBg = ComponentFactory.Instance.creatBitmap("asset.ddtvip.CellBg");
         this._itemTxt = ComponentFactory.Instance.creatComponentByStylename("ddtvip.itemTxt");
         this._itemTip = new OneLineTip();
         addChild(this._itemBg);
         addChild(this._itemTxt);
         addChild(this._itemTip);
         this._itemTip.visible = false;
      }
      
      public function setItem(param1:int) : void
      {
         this._vipInfo = VipPrivilegeConfigManager.Instance.getById(param1 + 1);
         this._SpreeBg = ComponentFactory.Instance.creatBitmap("asset.ddtVip.spcee" + (param1 + 1).toString());
         this._SpreeBg.width = 40;
         this._SpreeBg.height = 40;
         this._SpreeBg.x = 6;
         this._SpreeBg.y = 6;
         this._SpreeBg.smoothing = true;
         addChild(this._SpreeBg);
         this._itemTxt.text = LanguageMgr.GetTranslation("ddtvip.itemText" + (param1 + 1).toString());
         this._itemTip.tipData = LanguageMgr.GetTranslation("ddtvip.itemText.tips" + (param1 + 1).toString());
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOutHandler);
      }
      
      private function __onMouseOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._itemTip)
         {
            this._itemTip.visible = true;
            LayerManager.Instance.addToLayer(this._itemTip,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this._SpreeBg.localToGlobal(new Point(0,0));
            this._itemTip.x = _loc2_.x;
            this._itemTip.y = _loc2_.y + this._SpreeBg.height;
         }
      }
      
      private function __onMouseOutHandler(param1:MouseEvent) : void
      {
         if(this._itemTip)
         {
            this._itemTip.visible = false;
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOverHandler);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOutHandler);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._itemBg);
         this._itemBg = null;
         ObjectUtils.disposeObject(this._SpreeBg);
         this._SpreeBg = null;
         ObjectUtils.disposeObject(this._itemTxt);
         this._itemTxt = null;
         ObjectUtils.disposeObject(this._itemTip);
         this._itemTip = null;
      }
   }
}
