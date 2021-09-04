package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemAddInfo;
   
   public class TotemLeftWindowChapterTipView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _valueTxtList:Vector.<FilterFrameText>;
      
      private var _titleTxtList:Array;
      
      private var _numTxtList:Array;
      
      private var _propertyTxtList:Array;
      
      public function TotemLeftWindowChapterTipView()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._titleTxtList = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.titleListTxt").split(",");
         this._numTxtList = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.numListTxt").split(",");
         this._propertyTxtList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc2_:FilterFrameText = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.chapterTip.bg");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.titleTxt");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.nameTxt");
         addChild(this._bg);
         addChild(this._titleTxt);
         addChild(this._nameTxt);
         this._valueTxtList = new Vector.<FilterFrameText>();
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("totem.totemChapterTip.valueTxt");
            _loc2_.y += _loc1_ * 20;
            addChild(_loc2_);
            this._valueTxtList.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function show(param1:int) : void
      {
         var _loc2_:int = param1 - 1;
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.titleTxt",this._numTxtList[_loc2_],this._titleTxtList[_loc2_]);
         this._nameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemChapterTip.nameTxt",this._numTxtList[_loc2_]);
         var _loc3_:TotemAddInfo = TotemManager.instance.getAddInfo(param1 * 70,(param1 - 1) * 70 + 1);
         var _loc4_:int = 0;
         while(_loc4_ < 7)
         {
            this._valueTxtList[_loc4_].text = this._propertyTxtList[_loc4_] + "+" + TotemManager.instance.getAddValue(_loc4_ + 1,_loc3_);
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._titleTxt = null;
         this._nameTxt = null;
         this._valueTxtList = null;
         this._titleTxtList = null;
         this._numTxtList = null;
         this._propertyTxtList = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
