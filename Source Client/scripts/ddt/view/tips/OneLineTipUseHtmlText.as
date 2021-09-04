package ddt.view.tips
{
   import road7th.utils.StringHelper;
   
   public class OneLineTipUseHtmlText extends OneLineTip
   {
       
      
      public function OneLineTipUseHtmlText()
      {
         super();
      }
      
      override public function set tipData(param1:Object) : void
      {
         _data = param1;
         if(_data)
         {
            _contentTxt.htmlText = StringHelper.trim(String(_data));
            updateTransform();
            this.visible = true;
         }
         else
         {
            this.visible = false;
         }
      }
   }
}
