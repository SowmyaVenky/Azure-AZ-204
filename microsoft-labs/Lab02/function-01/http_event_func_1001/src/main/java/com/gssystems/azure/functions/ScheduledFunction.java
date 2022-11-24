package com.gssystems.azure.functions;

import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.TimerTrigger;

import java.time.LocalDateTime;

public class ScheduledFunction {
    /**
     * This method will be exposed as a function that will trigger every so often and do something important
     */

    @FunctionName("repeatOnSchedule")
    public void repeatOnSchedule(
            @TimerTrigger(name="repeatTrigger", schedule = "0 * */30 * * *") String timerInfo,
            ExecutionContext context
    ) {
        context.getLogger().info("The function has triggered at : " + LocalDateTime.now());
    }
}
