// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.TencentPlatformData

package platformapi.tencent
{
    public class TencentPlatformData 
    {

        public var openID:String;
        public var openKey:String;
        public var pf:String;
        public var pfKey:String;


        public function get pfType():int
        {
            switch (this.pf)
            {
                case "pengyou":
                case "qzone":
                    return (DiamondType.YELLOW_DIAMOND);
                case "3366":
                    return (DiamondType.BLUE_DIAMOND);
                case "qplus":
                    return (DiamondType.MEMBER_DIAMOND);
            };
            return (0);
        }


    }
}//package platformapi.tencent

