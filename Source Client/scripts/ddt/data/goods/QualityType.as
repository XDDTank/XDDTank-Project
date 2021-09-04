package ddt.data.goods
{
   import ddt.manager.LanguageMgr;
   
   public class QualityType
   {
      
      public static const QUALITY_STRING:Array = ["",LanguageMgr.GetTranslation("tank.data.QualityType.cucao"),LanguageMgr.GetTranslation("tank.data.QualityType.putong"),LanguageMgr.GetTranslation("tank.data.QualityType.youxiu"),LanguageMgr.GetTranslation("tank.data.QualityType.jingliang"),LanguageMgr.GetTranslation("tank.data.QualityType.zhuoyue"),LanguageMgr.GetTranslation("tank.data.QualityType.chuanshuo"),LanguageMgr.GetTranslation("tank.data.QualityType.shenqi")];
      
      public static const QUALITY_COLOR:Array = [0,14803425,2031360,164607,10696174,16744448,16711833,2949117];
      
      public static const EQUIP_QUALITY_COLOR:Array = [0,6277377,128510,13396991,16729014,16744448,0,14803425,2031360,164607,10696174,16744448,16711833,2949117,16777215,16777215,3407667,3407667,65535,65535,16711884,16711884];
      
      public static const COMPOSE_SKILL_QUALITY_COLOR:Array = [0,6277377,128510,13396991,16729014,16744448];
      
      public static const PET_QUALITY_COLOR:Array = [164607,10696174,16729014];
       
      
      public function QualityType()
      {
         super();
      }
   }
}
