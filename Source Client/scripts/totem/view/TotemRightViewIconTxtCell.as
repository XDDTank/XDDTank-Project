package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public class TotemRightViewIconTxtCell extends Sprite implements Disposeable
   {
       
      
      private var _iconComponent:Component;
      
      private var _icon:Bitmap;
      
      private var _txt:FilterFrameText;
      
      public function TotemRightViewIconTxtCell()
      {
         super();
         this._txt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.iconCell.txt");
         this._iconComponent = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.iconComponent");
      }
      
      public function show(param1:int) : void
      {
         if(param1 == 1 || param1 == 3)
         {
            this._icon = ComponentFactory.Instance.creatBitmap("asset.totem.rightView.exp");
            this._iconComponent.tipData = LanguageMgr.GetTranslation(param1 == 3 ? "ddt.totem.rightView.expTipTxt" : "ddt.totem.rightView.needExpTipTxt");
         }
         else if(param1 == 2 || param1 == 4)
         {
            this._icon = ComponentFactory.Instance.creatBitmap("asset.totem.rightView.honor");
            this._txt.y += 6;
            this._iconComponent.tipData = LanguageMgr.GetTranslation(param1 == 4 ? "ddt.totem.rightView.honorTipTxt" : "ddt.totem.rightView.needHonorTipTxt");
         }
         this._iconComponent.addChild(this._icon);
         addChild(this._iconComponent);
         addChild(this._txt);
      }
      
      public function refresh(param1:int, param2:Boolean = false) : void
      {
         this._txt.text = param1.toString();
         if(param2)
         {
            this._txt.setTextFormat(new TextFormat(null,null,16711680));
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._iconComponent = null;
         this._icon = null;
         this._txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
