package ai.sudoclaw.android.ui

import androidx.compose.runtime.Composable
import ai.sudoclaw.android.MainViewModel
import ai.sudoclaw.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
