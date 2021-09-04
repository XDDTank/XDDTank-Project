package bagAndInfo.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   
   public class EquipLock extends Component
   {
       
      
      private var _background:Bitmap;
      
      public function EquipLock()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._background = ComponentFactory.Instance.creatBitmap("assets.ddtbagAndInfo.equipLock");
         this._background.width = 52;
         this._background.height = 52;
         addChild(this._background);
      }
      
      public function gettipData(param1:int) : Object
      {
         if(param1 == 0)
         {
            tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.LockCell.25tips");
         }
         else if(param1 == 1)
         {
            tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.LockCell.30tips");
         }
         else if(param1 == 2)
         {
            tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.LockCell.35tips");
         }
         else if(param1 == 3 || param1 == 4)
         {
            tipData = LanguageMgr.GetTranslation("ddt.bagAndInfo.LockCell.40tips");
         }
         return tipData;
      }
   }
}
