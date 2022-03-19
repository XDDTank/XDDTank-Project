// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.StageTweenStrategys

package game.animations
{
    public class StageTweenStrategys 
    {


        public static function getTweenClassNameByShortName(_arg_1:String):String
        {
            switch (_arg_1)
            {
                case "default":
                    return ("game.animations.StrDefaultTween");
                case "directly":
                    return ("game.animations.StrDirectlyTween");
                case "lowSpeedLinear":
                    return ("game.animations.StrLinearTween");
                case "highSpeedLinear":
                    return ("game.animations.StrHighSpeedLinearTween");
                case "shockingLinear":
                    return ("game.animations.StrShockingLinearTween");
                case "stay":
                    return ("game.animations.StrStayTween");
                default:
                    return ("game.animations.StrDefaultTween");
            };
        }


    }
}//package game.animations

