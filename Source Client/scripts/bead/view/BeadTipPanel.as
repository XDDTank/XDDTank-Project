package bead.view
{
   import bead.BeadManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class BeadTipPanel extends BaseTip
   {
       
      
      public var MAX_H:int = 99;
      
      public var MAX_W:int = 180;
      
      protected var _bg:ScaleBitmapImage;
      
      protected var _hLine:ScaleBitmapImage;
      
      protected var _nameTxt:FilterFrameText;
      
      protected var _expLevelTxt:FilterFrameText;
      
      protected var _discTxt:FilterFrameText;
      
      protected var _container:Sprite;
      
      protected var _beadTipData:Object;
      
      public function BeadTipPanel()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initView();
         super.init();
         this.tipbackgound = this._bg;
      }
      
      protected function initView() : void
      {
         this._container = new Sprite();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._hLine = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadTip.hLine");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadTip.name");
         this._expLevelTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadTip.expLevel");
         this._discTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadTip.disc");
         this._bg.width = 180;
         this._container.addChild(this._bg);
         this._container.addChild(this._hLine);
         this._container.addChild(this._nameTxt);
         this._container.addChild(this._expLevelTxt);
         this._container.addChild(this._discTxt);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return this._beadTipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(!param1)
         {
            this.visible = false;
            this._beadTipData = null;
            return;
         }
         this._beadTipData = param1;
         this.visible = true;
         this.setTxt(param1);
         this.updateWH();
      }
      
      protected function setTxt(param1:Object) : void
      {
         var _loc2_:int = (param1 as InventoryItemInfo).beadLevel;
         var _loc3_:Array = BeadManager.instance.calExpLimit(param1 as InventoryItemInfo);
         this._nameTxt.htmlText = BeadManager.instance.getBeadColorName(param1 as InventoryItemInfo,true);
         this._expLevelTxt.text = LanguageMgr.GetTranslation("beadSystem.bead.expTxt",_loc3_[0],_loc3_[1]);
         this._discTxt.htmlText = BeadManager.instance.getDescriptionStr(param1 as InventoryItemInfo);
      }
      
      protected function updateWH() : void
      {
         this._bg.width = this.MAX_W;
         this._bg.height = this.MAX_H;
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      override public function dispose() : void
      {
         this._beadTipData = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._hLine)
         {
            ObjectUtils.disposeObject(this._hLine);
         }
         this._hLine = null;
         if(this._nameTxt)
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(this._expLevelTxt)
         {
            ObjectUtils.disposeObject(this._expLevelTxt);
         }
         this._expLevelTxt = null;
         if(this._discTxt)
         {
            ObjectUtils.disposeObject(this._discTxt);
         }
         this._discTxt = null;
         super.dispose();
      }
   }
}
