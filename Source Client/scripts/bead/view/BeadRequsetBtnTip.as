package bead.view
{
   import bead.BeadManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   
   public class BeadRequsetBtnTip extends BaseTip
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _nameTxt:FilterFrameText;
      
      private var _discTxt:FilterFrameText;
      
      private var _beadTipData:Object;
      
      private var _nameList:Array;
      
      private var _moneyList:Array;
      
      public function BeadRequsetBtnTip()
      {
         super();
         this.initView();
         this.initData();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.bg");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.name");
         this._discTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn.tip.disc");
         addChild(this._bg);
         addChild(this._nameTxt);
         addChild(this._discTxt);
      }
      
      private function initData() : void
      {
         var _loc1_:String = LanguageMgr.GetTranslation("beadSystem.requestBtn.tip.nameList");
         this._nameList = _loc1_.split(",");
         this._moneyList = BeadManager.instance.beadConfig.GemGold.split("|");
      }
      
      override public function get tipData() : Object
      {
         return this._beadTipData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         this._beadTipData = param1;
         var _loc2_:int = int(param1);
         if(_loc2_ >= 1 && _loc2_ <= 4)
         {
            _loc3_ = this._nameList[_loc2_ - 1];
            _loc4_ = this._moneyList[_loc2_ - 1];
         }
         else
         {
            _loc3_ = "";
            _loc4_ = 0;
         }
         this._nameTxt.text = _loc3_;
         this._discTxt.text = LanguageMgr.GetTranslation("beadSystem.requestBtn.tip.discStr",_loc4_.toString());
         this.updateSize();
      }
      
      private function updateSize() : void
      {
         this._bg.width = this._discTxt.x + this._discTxt.width + 15;
         this._bg.height = this._discTxt.y + this._discTxt.height + 10;
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
         if(this._nameTxt)
         {
            ObjectUtils.disposeObject(this._nameTxt);
         }
         this._nameTxt = null;
         if(this._discTxt)
         {
            ObjectUtils.disposeObject(this._discTxt);
         }
         this._discTxt = null;
         super.dispose();
      }
   }
}
