package ddt.view.bossbox
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class PetPropertyItem extends Sprite implements Disposeable
   {
       
      
      private var _nameTxt:FilterFrameText;
      
      private var _baseTxt:FilterFrameText;
      
      private var _growTxt:FilterFrameText;
      
      private var _type:int;
      
      public function PetPropertyItem(param1:int)
      {
         this._type = param1;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._nameTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyNameTxt");
         addChild(this._nameTxt);
         switch(this._type)
         {
            case 0:
               this._nameTxt.text = LanguageMgr.GetTranslation("MaxHp");
               break;
            case 1:
               this._nameTxt.text = LanguageMgr.GetTranslation("attack");
               break;
            case 2:
               this._nameTxt.text = LanguageMgr.GetTranslation("defence");
               break;
            case 3:
               this._nameTxt.text = LanguageMgr.GetTranslation("agility");
               break;
            case 4:
               this._nameTxt.text = LanguageMgr.GetTranslation("luck");
         }
         this._baseTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyBaseTxt");
         addChild(this._baseTxt);
         this._growTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyGrowTxt");
         addChild(this._growTxt);
      }
      
      public function setValue(param1:Number, param2:Number) : void
      {
         this._baseTxt.text = param1.toString();
         this._growTxt.text = param2.toString();
      }
      
      public function setHighLight(param1:Boolean) : void
      {
         this._baseTxt.textFormatStyle = !!param1 ? "bossbox.petAwardView.propertyMaxTF" : "bossbox.petAwardView.propertybaseTF";
         this._growTxt.textFormatStyle = !!param1 ? "bossbox.petAwardView.propertyMaxTF" : "bossbox.petAwardView.propertyGrowTF";
         this._baseTxt.filterString = !!param1 ? "bossbox.petAwardView.propertyMaxGF" : "bossbox.petAwardView.propertybaseGF";
         this._growTxt.filterString = !!param1 ? "bossbox.petAwardView.propertyMaxGF" : "bossbox.petAwardView.propertyGrowGF";
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._baseTxt);
         this._baseTxt = null;
         ObjectUtils.disposeObject(this._growTxt);
         this._growTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
