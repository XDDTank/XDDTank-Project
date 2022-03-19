// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.FaceSource

package ddt.view
{
    import com.pickgliss.loader.DisplayLoader;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.MovieClip;

    public class FaceSource 
    {


        public static function getFaceById(_arg_1:int):MovieClip
        {
            if ((((_arg_1 < 75) && (_arg_1 > 0)) && (DisplayLoader.Context.applicationDomain.hasDefinition(("asset.core.expression.Expresion0" + ((_arg_1 < 10) ? ("0" + String(_arg_1)) : String(_arg_1)))))))
            {
                return (ClassUtils.CreatInstance(("asset.core.expression.Expresion0" + ((_arg_1 < 10) ? ("0" + String(_arg_1)) : String(_arg_1)))) as MovieClip);
            };
            return (null);
        }

        public static function getSFaceById(_arg_1:int):MovieClip
        {
            if (((_arg_1 < 49) && (_arg_1 > 0)))
            {
                return (ClassUtils.CreatInstance(("sFace_0" + ((_arg_1 < 10) ? ("0" + String(_arg_1)) : String(_arg_1)))) as MovieClip);
            };
            return (null);
        }

        public static function stringIsFace(_arg_1:String):int
        {
            if ((((!(_arg_1.length == 3)) && (!(_arg_1.length == 2))) || (!(_arg_1.slice(0, 1) == "/"))))
            {
                return (-1);
            };
            var _local_2:Number = Number(_arg_1.slice(1));
            if (((_local_2 < 49) && (_local_2 > 0)))
            {
                return (_local_2);
            };
            return (-1);
        }


    }
}//package ddt.view

