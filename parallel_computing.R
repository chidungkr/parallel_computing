

#-------------------------------------------------
#  Thiết lập môi trường cho tính toán song song
#-------------------------------------------------

library(doParallel)

# Số nhân tối đa có thể sử dụng của máy tính: 
detectCores()

# Số nhân máy tính hiện đang được sử dụng bởi máy tính: 
getDoParWorkers()

# Chỉ thị số nhân được sử dụng khi tính toán là 6: 
registerDoParallel(8 - 2)

# Kiểm tra lại để thấy rằng số nhân đang được sử dụng là 6: 
getDoParWorkers()

#-------------------------------------------------
#  So sánh thời gian thực thi của hai cách thức
#-------------------------------------------------

library(caret)
data("GermanCredit")

# Thực hiện Random Forest không sử dụng tính toán song song: 

library(randomForest)
system.time(rf_serial <- randomForest(GermanCredit[, -10], GermanCredit[, 10], ntree = 1000))

# Thực hiện tính toán song song: 

system.time(
  rf_paralled <- foreach(nt = rep(200, 5), .combine = combine, .packages = "randomForest") %dopar%
    randomForest(GermanCredit[, -10], GermanCredit[, 10], ntree = nt))

# So sánh với 10 lần chạy khác nhau có thể thấy thời gian 
# huấn luyện mô hình Random Forest chênh lệch nhau xấp xỉ 3 lần: 

microbenchmark::microbenchmark(
  # RF không sử dụng tính toán song song: 
  rf_serial <- randomForest(GermanCredit[, -10], GermanCredit[, 10], ntree = 1000),
  # RF sử dụng tính toán song song: 
  rf_paralled <- foreach(nt = rep(200, 5), .combine = combine, .packages = "randomForest") %dopar%
    randomForest(GermanCredit[, -10], GermanCredit[, 10], ntree = nt), 
  # Thực hiện huấn luyện 10 lần: 
  times = 10)



















