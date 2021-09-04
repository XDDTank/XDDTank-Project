package platformapi.tencent
{
   public class TencentPlatformData
   {
       
      
      public var openID:String;
      
      public var openKey:String;
      
      public var pf:String;
      
      public var pfKey:String;
      
      public function TencentPlatformData()
      {
         super();
      }
      
      public function get pfType() : int
      {
         switch(this.pf)
         {
            case "pengyou":
            case "qzone":
               return DiamondType.YELLOW_DIAMOND;
            case "3366":
               return DiamondType.BLUE_DIAMOND;
            case "qplus":
               return DiamondType.MEMBER_DIAMOND;
            default:
               return 0;
         }
      }
   }
}
