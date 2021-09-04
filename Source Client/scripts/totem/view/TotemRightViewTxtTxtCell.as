package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import totem.TotemManager;
   import totem.data.TotemAddInfo;
   
   public class TotemRightViewTxtTxtCell extends Sprite implements Disposeable
   {
       
      
      private var _upTxt:FilterFrameText;
      
      private var _downTxt:FilterFrameText;
      
      private var _txtArray:Array;
      
      private var _type:int;
      
      public function TotemRightViewTxtTxtCell()
      {
         super();
         this._upTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.txtCell.upTxt");
         this._downTxt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.txtCell.downTxt");
         var _loc1_:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
         this._txtArray = _loc1_.split(",");
         addChild(this._upTxt);
         addChild(this._downTxt);
      }
      
      public function show(param1:int) : void
      {
         this._upTxt.text = this._txtArray[param1 - 1];
         this._type = param1;
         this.refresh();
      }
      
      public function refresh() : void
      {
         var _loc1_:TotemAddInfo = TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId));
         switch(this._type)
         {
            case 1:
               this._downTxt.text = _loc1_.Attack.toString();
               break;
            case 2:
               this._downTxt.text = _loc1_.Defence.toString();
               break;
            case 3:
               this._downTxt.text = _loc1_.Agility.toString();
               break;
            case 4:
               this._downTxt.text = _loc1_.Luck.toString();
               break;
            case 5:
               this._downTxt.text = _loc1_.Blood.toString();
               break;
            case 6:
               this._downTxt.text = _loc1_.Damage.toString();
               break;
            case 7:
               this._downTxt.text = _loc1_.Guard.toString();
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._upTxt = null;
         this._downTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
