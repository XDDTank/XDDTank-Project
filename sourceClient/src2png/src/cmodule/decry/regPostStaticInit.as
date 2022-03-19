// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.regPostStaticInit

package cmodule.decry
{
    public function regPostStaticInit(_arg_1:Function):void
    {
        if ((!(gpostStaticInits)))
        {
            gpostStaticInits = [];
        };
        gpostStaticInits.push(_arg_1);
    }

}//package cmodule.decry

