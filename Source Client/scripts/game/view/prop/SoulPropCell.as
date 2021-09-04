package game.view.prop
{
   import ddt.view.tips.ToolPropInfo;
   import game.GameManager;
   
   public class SoulPropCell extends PropCell
   {
       
      
      public function SoulPropCell()
      {
         super();
         this.enabled = false;
         _tipInfo.valueType = ToolPropInfo.Psychic;
         this.setGrayFilter();
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(!param1)
         {
            super.enabled = param1;
         }
         else if(GameManager.Instance.Current.currentLiving.isBoss && (info.TemplateID == 10016 || info.TemplateID == 10017 || info.TemplateID == 10018 || info.TemplateID == 10015 || info.TemplateID == 10022))
         {
            super.enabled = false;
         }
         else
         {
            super.enabled = param1;
         }
      }
      
      override public function setPossiton(param1:int, param2:int) : void
      {
         super.setPossiton(param1,param2);
         this.x = _x;
         this.y = _y;
      }
   }
}
