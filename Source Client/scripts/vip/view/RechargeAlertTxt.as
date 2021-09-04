package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class RechargeAlertTxt extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _title:FilterFrameText;
      
      private var _content:FilterFrameText;
      
      public function RechargeAlertTxt()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._title = ComponentFactory.Instance.creat("VipRechargeLV.titleTxt");
         addChild(this._title);
         this._content = ComponentFactory.Instance.creat("VipRechargeLV.contentTxt");
         addChild(this._content);
      }
      
      public function set AlertContent(param1:int) : void
      {
         this._title.text = this.getAlertTitle(param1);
         this._content.text = this.getAlertTxt(param1);
      }
      
      private function getAlertTxt(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
               _loc2_ += "1、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param0")) + "\n";
               _loc2_ += "2、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2Param")) + "\n";
               _loc2_ += "3、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += "4、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4Param0")) + "\n";
               _loc2_ += "5、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param0")) + "\n";
               _loc2_ += "6、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7Param0")) + "\n";
               _loc2_ += "7、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8") + "\n";
               _loc2_ += "8、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent9") + "\n";
               _loc2_ += "9、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent10",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent10Param0")) + "\n";
               _loc2_ += "10、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent11",";") + "\n";
               _loc2_ += "11、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param0"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param2")) + "\n";
               _loc2_ += "            " + "\n";
               break;
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent13") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent14") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent15") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent16") + "\n";
               _loc2_ += LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent17") + "\n";
               _loc2_ += "6、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent1Param1")) + "\n";
               _loc2_ += "7、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent4Param1")) + "\n";
               _loc2_ += "8、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent7Param1")) + "\n";
               _loc2_ += "9、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent3Param")) + "\n";
               _loc2_ += "10、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent2Param")) + "\n";
               _loc2_ += "11、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent8") + "\n";
               _loc2_ += "12、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent5Param1")) + "\n";
               _loc2_ += "13、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent11",";") + "\n";
               _loc2_ += "14、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent9") + "\n";
               _loc2_ += "15、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent10",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent10Param1")) + "\n";
               _loc2_ += "16、" + LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12",LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param1"),LanguageMgr.GetTranslation("tank.vip.rechargeAlertContent12Param3")) + "\n";
               _loc2_ += "            " + "\n";
         }
         return _loc2_;
      }
      
      private function getAlertTitle(param1:int) : String
      {
         var _loc2_:String = "";
         switch(param1)
         {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
               _loc2_ = LanguageMgr.GetTranslation("tank.vip.rechargeAlertTitle",6);
               break;
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
            case 12:
               _loc2_ = LanguageMgr.GetTranslation("tank.vip.rechargeAlertEndTitle",12);
         }
         return _loc2_;
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         if(this._content)
         {
            ObjectUtils.disposeObject(this._content);
            this._content = null;
         }
      }
   }
}
